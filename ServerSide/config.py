import os
import json

class Config:
    def __init__(self, env='local'):
        self.env = env
        self.load_config()
    
    def load_config(self):
        config_file = f'config_{self.env}.json'
        
        configs = {
            'local': {
                'host': '192.168.1.27',
                'port': 5000,
                'debug': True,
                'database': 'database.db'
            },
            'local2': {
                'host': '10.0.0.19',
                'port': 5000,
                'debug': True,
                'database': 'database.db'
            },
            'production': {
                'host': '10.0.0.19',
                'port': 5051,
                'debug': False,
                'database': 'database.db'
            },
        }
        
        self.config = configs.get(self.env, configs['local'])
        
        if os.path.exists(config_file):
            try:
                with open(config_file, 'r') as f:
                    file_config = json.load(f)
                    self.config.update(file_config)
            except (json.JSONDecodeError, IOError):
                pass
        self.config['host'] = os.getenv('FLASK_HOST', self.config['host'])
        self.config['port'] = int(os.getenv('FLASK_PORT', self.config['port']))
        self.config['debug'] = os.getenv('FLASK_DEBUG', str(self.config['debug'])).lower() == 'true'
        self.config['database'] = os.getenv('DATABASE_PATH', self.config['database'])
    
    def get(self, key, default=None):
        return self.config.get(key, default)
    
    def get_flask_config(self):
        return {
            'host': self.get('host'),
            'port': self.get('port'),
            'debug': self.get('debug')
        }
