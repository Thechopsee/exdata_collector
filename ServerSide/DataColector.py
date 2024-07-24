from flask import Flask, request, jsonify
import datetime
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
#DOdelat akce id
class Run(db.Model):
    rid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    boatID = db.Column(db.Integer, db.ForeignKey('boat.bID'), nullable=False)
    rcid = db.Column(db.Integer, db.ForeignKey('race.rcid'), nullable=False)
    scopeTo = db.Column(db.Integer)
    directionTo = db.Column(db.String)
    hit = db.Column(db.Integer)
    hitDirection = db.Column(db.String)

class Race(db.Model):
    rcid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    date = db.Column(db.DateTime, nullable=False)

    def to_json(self):
        return {
            'name': self.name,
            'date': self.date.isoformat(),
            'rcid': self.rcid,
            'drcid': self.rcid,
        }

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
              
@app.route('/runs/sync', methods=['POST'])
def check_sync_run():
    data = request.get_json()
    idlist = data['runList']
    isUnsync=False
    for x in idlist:
        if(x['drid']==0):
            print(x)
            new_run=Run(boatID=x['boatID'],scopeTo=x['scopeToo'],directionTo=x['directionToo'],hit=x['hit'],hitDirection=x['directionHit'],rcid=x['rcid'])
            db.session.add(new_run)
            db.session.commit()
            isUnsync=True
    runs = Run.query.all()
    runsArray=[{'rid': run.rid,'drid':run.rid, 'boatID': run.boatID, 'scopeToo': run.scopeTo,'directionToo':run.directionTo,'hit':run.hit,'directionHit':run.hitDirection,'rcid':run.rcid} for run in runs]
    return jsonify(runsArray),200

@app.route('/races/sync', methods=['POST'])
def check_sync_race():
    data = request.get_json()
    idlist = data['raceList']
    isUnsync=False
    print(idlist)
    for x in idlist:
        if(x['drcid']==0):
            print(x)
            date_object = datetime.datetime.strptime(x["date"], '%Y-%m-%dT%H:%M:%S.%f')
            new_run=Race(name=x["name"],date=date_object)
            db.session.add(new_run)
            db.session.commit()
            isUnsync=True
    races = Race.query.all()
    racesArray=[race.to_json() for race in races]
    return jsonify(racesArray),200

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

# Create a new Race
@app.route('/races', methods=['POST'])
def create_race():
    new_race = Race.from_json(request.json)
    db.session.add(new_race)
    db.session.commit()
    return jsonify(new_race.to_json()), 201

@app.route('/races', methods=['GET'])
def get_races():
    races = Race.query.all()
    return jsonify([race.to_json() for race in races])

@app.route('/races/<int:id>', methods=['GET'])
def get_race(id):
    race = Race.query.get_or_404(id)
    return jsonify(race.to_json())

@app.route('/races/<int:id>', methods=['PUT'])
def update_race(id):
    race = Race.query.get_or_404(id)
    if 'name' in request.json:
        race.name = request.json['name']
    if 'date' in request.json:
        race.date = datetime.fromisoformat(request.json['date'])
    if 'rcid' in request.json:
        race.rcid = request.json['rcid']
    if 'drcid' in request.json:
        race.drcid = request.json['drcid']
    db.session.commit()
    return jsonify(race.to_json())

@app.route('/races/<int:id>', methods=['DELETE'])
def delete_race(id):
    race = Race.query.get_or_404(id)
    db.session.delete(race)
    db.session.commit()
    return jsonify({'result': True})


if __name__ == '__main__':
    app.run(debug=True)
    