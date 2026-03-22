from flask import Flask, request, jsonify, render_template
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from config import Config

env = sys.argv[1] if len(sys.argv) > 1 else 'local'
config = Config(env)

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{config.get("database")}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Boat(db.Model):
    bID = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    boatClass = db.Column(db.String, nullable=False)
    timerSeconds = db.Column(db.String)
    timerExplanation = db.Column(db.String)
    image = db.Column(db.String)
    runs = db.relationship('Run', backref='boat', lazy=True)

class Run(db.Model):
    rid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    boatID = db.Column(db.Integer, db.ForeignKey('boat.bID'), nullable=False)
    rcid = db.Column(db.Integer, db.ForeignKey('race.rcid'), nullable=False)
    scopeTo = db.Column(db.Integer)
    directionTo = db.Column(db.String)
    hit = db.Column(db.Integer)
    hitDirection = db.Column(db.String)
    intendedPartOfGate = db.Column(db.String)
    dateTime = db.Column(db.DateTime, default=datetime.utcnow)

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
        if(x.get('dbID', 0) < 1):
            new_boat = Boat(
                name=x['name'],
                boatClass=x['boatClass'],
                timerSeconds=x.get('timerSeconds'),
                timerExplanation=x.get('timerExplanation'),
                image=x.get('image')
            )
            db.session.add(new_boat)
            db.session.commit()
            isUnsync=True
    boats = Boat.query.all()
    boatArray=[{
        'bID': boat.bID,
        'dbID': boat.bID,
        'name': boat.name,
        'boatClass': boat.boatClass,
        'timerSeconds': boat.timerSeconds,
        'timerExplanation': boat.timerExplanation,
        'image': boat.image
    } for boat in boats]

    return jsonify(boatArray), 200
              
@app.route('/runs/sync', methods=['POST'])
def check_sync_run():
    data = request.get_json()
    idlist = data['runList']
    isUnsync=False
    for x in idlist:
        if(x.get('drid', 0) == 0):
            dt = datetime.fromisoformat(x['dateTime']) if x.get('dateTime') else datetime.utcnow()
            new_run=Run(
                boatID=x['boatID'],
                scopeTo=x.get('scopeTo'),
                directionTo=x.get('directionTo'),
                hit=x.get('hit'),
                hitDirection=x.get('directionHit'),
                rcid=x['rcid'],
                intendedPartOfGate=x.get('intendedPartOfGate'),
                dateTime=dt
            )
            db.session.add(new_run)
            db.session.commit()
            isUnsync=True
    runs = Run.query.all()
    runsArray=[{
        'rid': run.rid,
        'drid': run.rid,
        'boatID': run.boatID,
        'scopeTo': run.scopeTo,
        'directionTo': run.directionTo,
        'hit': run.hit,
        'directionHit': run.hitDirection,
        'rcid': run.rcid,
        'intendedPartOfGate': run.intendedPartOfGate,
        'dateTime': run.dateTime.isoformat()
    } for run in runs]
    return jsonify(runsArray),200

@app.route('/races/sync', methods=['POST'])
def check_sync_race():
    data = request.get_json()
    idlist = data['raceList']
    isUnsync=False
    for x in idlist:
        if(x.get('drcid', 0) == 0):
            date_object = datetime.fromisoformat(x["date"])
            new_race=Race(name=x["name"], date=date_object)
            db.session.add(new_race)
            db.session.commit()
            isUnsync=True
    races = Race.query.all()
    racesArray=[race.to_json() for race in races]
    return jsonify(racesArray),200

@app.route('/boats', methods=['POST'])
def create_boat():
    data = request.get_json()
    new_boat = Boat(
        name=data['name'],
        boatClass=data['boatClass'],
        timerSeconds=data.get('timerSeconds'),
        timerExplanation=data.get('timerExplanation'),
        image=data.get('image')
    )
    db.session.add(new_boat)
    db.session.commit()
    return jsonify({'message': 'Boat created'}), 201

@app.route('/boats', methods=['GET'])
def get_boats():
    boats = Boat.query.all()
    return jsonify([{
        'bID': boat.bID,
        'name': boat.name,
        'boatClass': boat.boatClass,
        'timerSeconds': boat.timerSeconds,
        'timerExplanation': boat.timerExplanation,
        'image': boat.image
    } for boat in boats])

@app.route('/boats/<int:id>', methods=['GET'])
def get_boat(id):
    boat = Boat.query.get_or_404(id)
    return jsonify({
        'bID': boat.bID,
        'name': boat.name,
        'boatClass': boat.boatClass,
        'timerSeconds': boat.timerSeconds,
        'timerExplanation': boat.timerExplanation,
        'image': boat.image
    })

@app.route('/boats/<int:id>', methods=['PUT'])
def update_boat(id):
    data = request.get_json()
    boat = Boat.query.get_or_404(id)
    boat.name = data['name']
    boat.boatClass = data['boatClass']
    boat.timerSeconds = data.get('timerSeconds')
    boat.timerExplanation = data.get('timerExplanation')
    boat.image = data.get('image')
    db.session.commit()
    return jsonify({'message': 'Boat updated'})

@app.route('/boats/<int:id>', methods=['DELETE'])
def delete_boat(id):
    boat = Boat.query.get_or_404(id)
    db.session.delete(boat)
    db.session.commit()
    return jsonify({'message': 'Boat deleted'})

@app.route('/runs', methods=['POST'])
def create_run():
    data = request.get_json()
    dt = datetime.fromisoformat(data['dateTime']) if data.get('dateTime') else datetime.utcnow()
    new_run = Run(
        boatID=data['boatID'],
        rcid=data['rcid'],
        scopeTo=data.get('scopeTo'),
        directionTo=data.get('directionTo'),
        hit=data.get('hit'),
        hitDirection=data.get('directionHit'),
        intendedPartOfGate=data.get('intendedPartOfGate'),
        dateTime=dt
    )
    db.session.add(new_run)
    db.session.commit()
    return jsonify({'message': 'Run created'}), 201

@app.route('/runs', methods=['GET'])
def get_runs():
    runs = Run.query.all()
    return jsonify([{
        'rid': run.rid,
        'boatID': run.boatID,
        'rcid': run.rcid,
        'scopeTo': run.scopeTo,
        'directionTo': run.directionTo,
        'hit': run.hit,
        'directionHit': run.hitDirection,
        'intendedPartOfGate': run.intendedPartOfGate,
        'dateTime': run.dateTime.isoformat()
    } for run in runs])

@app.route('/runs/<int:id>', methods=['GET'])
def get_run(id):
    run = Run.query.get_or_404(id)
    return jsonify({
        'rid': run.rid,
        'boatID': run.boatID,
        'rcid': run.rcid,
        'scopeTo': run.scopeTo,
        'directionTo': run.directionTo,
        'hit': run.hit,
        'directionHit': run.hitDirection,
        'intendedPartOfGate': run.intendedPartOfGate,
        'dateTime': run.dateTime.isoformat()
    })

@app.route('/runs/<int:id>', methods=['PUT'])
def update_run(id):
    data = request.get_json()
    run = Run.query.get_or_404(id)
    run.boatID = data['boatID']
    run.rcid = data['rcid']
    run.scopeTo = data.get('scopeTo')
    run.directionTo = data.get('directionTo')
    run.hit = data.get('hit')
    run.hitDirection = data.get('directionHit')
    run.intendedPartOfGate = data.get('intendedPartOfGate')
    if data.get('dateTime'):
        run.dateTime = datetime.fromisoformat(data['dateTime'])
    db.session.commit()
    return jsonify({'message': 'Run updated'})

@app.route('/runs/<int:id>', methods=['DELETE'])
def delete_run(id):
    run = Run.query.get_or_404(id)
    db.session.delete(run)
    db.session.commit()
    return jsonify({'message': 'Run deleted'})

@app.route('/', methods=['GET'])
def home():
    return render_template('home.html')

@app.route('/races', methods=['POST'])
def create_race():
    data = request.get_json()
    new_race = Race(
        name=data['name'],
        date=datetime.fromisoformat(data['date'])
    )
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
    db.session.commit()
    return jsonify(race.to_json())

@app.route('/races/<int:id>', methods=['DELETE'])
def delete_race(id):
    race = Race.query.get_or_404(id)
    db.session.delete(race)
    db.session.commit()
    return jsonify({'result': True})

@app.route('/Heath', methods=['GET'])
def health_check():
    return jsonify({'status': 'ok'}), 200


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    
    flask_config = config.get_flask_config()
    print(f"Starting server with configuration: {env}")
    print(f"Host: {flask_config['host']}")
    print(f"Port: {flask_config['port']}")
    print(f"Debug: {flask_config['debug']}")
    
    app.run(**flask_config)
