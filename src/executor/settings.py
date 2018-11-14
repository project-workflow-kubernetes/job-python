import os

RESOURCES_PATH = os.path.join(os.path.abspath(os.path.join(__file__, '../../..')), 'resources')
LOGS_PREFIX = os.environ['LOGS_OUTPUT_PATH'] if os.environ.get('LOGS_OUTPUT_PATH', None) else RESOURCES_PATH
LOGS_PATH = os.path.join(LOGS_PREFIX, 'logs.log')
