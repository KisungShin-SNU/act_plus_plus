# flake8: noqa

import os

# Try to import ALOHA package's DATA_DIR, else default to ~/aloha_data
try:
    from aloha.constants import DATA_DIR
except ImportError:
    DATA_DIR = os.path.expanduser('~/aloha_data')

DATA_DIR = '../data'

TASK_CONFIGS = {

    'aloha_mobile_hello_aloha':{
        'dataset_dir': DATA_DIR + '/aloha_mobile_hello_aloha',
        'episode_len': 800,
        'camera_names': ['cam_high', 'cam_left_wrist', 'cam_right_wrist']
    },

    'aloha_mobile_towel':{
        'dataset_dir': DATA_DIR + '/towel',
        'num_episodes': 50,
        'episode_len': 1000,
        'camera_names': ['cam_high', 'cam_left_wrist', 'cam_right_wrist']
    },

    'aloha_mobile_towel_aug':{
        'dataset_dir': DATA_DIR + '/towel_augmented/aligned_episodes',
        'num_episodes': 1050,
        'episode_len': 1000,
        'camera_names': ['cam_high', 'cam_left_wrist', 'cam_right_wrist']
    },

    'aloha_mobile_emart_bag':{
        'dataset_dir': DATA_DIR + '/emart_bag(sjj_250624)',
        'num_episodes': 50,
        'episode_len': 1000,
        'camera_names': ['cam_high', 'cam_left_wrist', 'cam_right_wrist']
    },

}
