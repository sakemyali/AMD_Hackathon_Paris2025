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
  --dataset.repo_id=sakemyali/eval_actm2v2_1 \
  --dataset.num_episodes=1 \
  --dataset.single_task="pick up the croissant" \
  --dataset.push_to_hub=False \
  --dataset.episode_time_s=600 \
  --dataset.reset_time_s=1 \
  --policy.path=sakemyali/actm2_v2
