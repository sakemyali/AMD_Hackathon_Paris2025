#!/bin/bash


lerobot-record \
    --robot.type=so101_follower \
    --robot.port=/dev/ttyACM1 \
    --robot.id=follower_arm \
    --robot.cameras="{top: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30}, side: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, arm: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 30}}" \
    --teleop.type=so101_leader \
    --teleop.port=/dev/ttyACM0 \
    --teleop.id=leader_arm \
    --display_data=true \
    --dataset.repo_id=sakemyali/mission2 \
    --dataset.num_episodes=20 \
    --dataset.episode_time_s=40 \
    --dataset.reset_time_s=10 \
    --dataset.single_task="pickup croissant" \
    --dataset.root=sakemyali/set_m2/ \
    --dataset.push_to_hub=False \
    --resume=False
