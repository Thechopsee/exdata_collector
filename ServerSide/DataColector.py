from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Boat(db.Model):
    bID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    boatClass = db.Column(db.String, nullable=False)
    runs = db.relationship('Run', backref='boat', lazy=True)

class Run(db.Model):
    rid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    boatID = db.Column(db.Integer, db.ForeignKey('boat.bID'), nullable=False)
    scopeTo = db.Column(db.Integer)
    directionTo = db.Column(db.String)
    hit = db.Column(db.Integer)
    hitDirection = db.Column(db.String)

@app.route('/boats/sync', methods=['POST'])
def check_sync_boat():
    data = request.get_json()
    idlist = data['boatList']
    isUnsync=False
    for x in idlist:
        
        if(x['dbID']<1):
            print(x)
            new_boat = Boat(name=x['name'], boatClass=x['boatClass'])
            db.session.add(new_boat)
            db.session.commit()
            isUnsync=True
    boats = Boat.query.all()
    boatArray=[{'bID': boat.bID, 'name': boat.name, 'boatClass': boat.boatClass} for boat in boats]
    if(len(boatArray)!=len(idlist)):
        isUnsync=True
    if(isUnsync):
        return jsonify(boatArray)  
    else:
        print("ok")
        return jsonify([]),200
              
        
@app.route('/boats', methods=['POST'])
def create_boat():
    data = request.get_json()
    new_boat = Boat(name=data['name'], boatClass=data['boatClass'])
    db.session.add(new_boat)
    db.session.commit()
    return jsonify({'message': 'Boat created'}), 201

@app.route('/boats', methods=['GET'])
def get_boats():
    boats = Boat.query.all()
    return jsonify([{'bID': boat.bID, 'name': boat.name, 'boatClass': boat.boatClass} for boat in boats])

@app.route('/boats/<int:id>', methods=['GET'])
def get_boat(id):
    boat = Boat.query.get_or_404(id)
    return jsonify({'bID': boat.bID, 'name': boat.name, 'boatClass': boat.boatClass})

@app.route('/boats/<int:id>', methods=['PUT'])
def update_boat(id):
    data = request.get_json()
    boat = Boat.query.get_or_404(id)
    boat.name = data['name']
    boat.boatClass = data['boatClass']
    db.session.commit()
    return jsonify({'message': 'Boat updated'})

@app.route('/boats/<int:id>', methods=['DELETE'])
def delete_boat(id):
    boat = Boat.query.get_or_404(id)
    db.session.delete(boat)
    db.session.commit()
    return jsonify({'message': 'Boat deleted'})

# CRUD for Run
@app.route('/runs', methods=['POST'])
def create_run():
    data = request.get_json()
    new_run = Run(
        boat=data['boat'],
        scopeTo=data.get('scopeTo'),
        directionTo=data.get('directionTo'),
        hit=data.get('hit'),
        hitDirection=data.get('hitDirection')
    )
    db.session.add(new_run)
    db.session.commit()
    return jsonify({'message': 'Run created'}), 201

@app.route('/runs', methods=['GET'])
def get_runs():
    runs = Run.query.all()
    return jsonify([{
        'rid': run.rid,
        'boatID': run.boat,
        'scopeTo': run.scopeTo,
        'directionTo': run.directionTo,
        'hit': run.hit,
        'hitDirection': run.hitDirection
    } for run in runs])

@app.route('/runs/<int:id>', methods=['GET'])
def get_run(id):
    run = Run.query.get_or_404(id)
    return jsonify({
        'rid': run.rid,
        'boat': run.boat,
        'scopeTo': run.scopeTo,
        'directionTo': run.directionTo,
        'hit': run.hit,
        'hitDirection': run.hitDirection
    })

@app.route('/runs/<int:id>', methods=['PUT'])
def update_run(id):
    data = request.get_json()
    run = Run.query.get_or_404(id)
    run.boatID = data['boat']
    run.scopeTo = data.get('scopeTo')
    run.directionTo = data.get('directionTo')
    run.hit = data.get('hit')
    run.hitDirection = data.get('hitDirection')
    db.session.commit()
    return jsonify({'message': 'Run updated'})

@app.route('/runs/<int:id>', methods=['DELETE'])
def delete_run(id):
    run = Run.query.get_or_404(id)
    db.session.delete(run)
    db.session.commit()
    return jsonify({'message': 'Run deleted'})
@app.route('/', methods=['GET'])
def de():
    db.create_all()
    return jsonify({'message': 'Run deleted'})

if __name__ == '__main__':
    app.run(debug=True)
    