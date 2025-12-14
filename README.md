
# ☕🥐 KACM – Coffee & Croissant Robot Manipulation

**AMD Robotics Hackathon 2025**

**Team:** KACM

---

## Overview

This repository contains our submission for the **AMD Robotics Hackathon 2025**.

Our objective was to train a real robot to perform **object-aware manipulation tasks** in a household-style setting, including:

* Picking up a **croissant**
* Dipping it carefully into a cup of **coffee**
* Ignoring non-target objects
* Picking up a **baguette** and handing it safely to a human

We explored **two learning-based robotic policies independently** using the **LeRobot framework**:

* **ACT (Action Chunking Transformers)** – imitation learning for manipulation
* **Vision-Language-Action (VLA) models** (**π0, SmolVLA**) – object selection and semantic grounding

Each policy was **trained and evaluated separately** on the same robotic setup and dataset.

---

## Project Goals

* Demonstrate **precise real-world manipulation**
* Enable **object-aware behavior** (croissant vs baguette vs other items)
* Evaluate different policy families on the **same real task**
* Use **teleoperated demonstrations** with real robot hardware

---

## Robot Setup

* **Robot:** SO-101 follower arm + leader arm (teleoperation)
* **Cameras (3 views):**

  | Camera  | Purpose                            |
  | ------- | ---------------------------------- |
  | Gripper | Fine grasping and manipulation     |
  | Top     | Workspace overview                 |
  | Side    | Depth cues and collision awareness |
* **Resolution:** 640×480
* **Frame Rate:** 30 FPS

---

## Learning Approaches

### 1. ACT – Action Chunking Transformers

* **Type:** Imitation Learning
* **Inputs:**

  * Multi-view RGB images
  * Robot joint states
* **Outputs:**

  * Action chunks (joint-level control)
* **Strengths:**

  * Smooth, precise manipulation
  * Reliable execution of pick, dip, and handover motions
* **Limitations:**

  * No semantic understanding of objects

ACT was used to **learn full manipulation trajectories** directly from human teleoperation.

---

### 2. Vision-Language-Action Models (π0, SmolVLA)

* **Type:** Vision-Language-Action (VLA)
* **Inputs:**

  * Multi-view images
  * Optional language prompts (e.g., “pick the croissant”)
* **Outputs:**

  * Object-conditioned actions
* **Strengths:**

  * Semantic object discrimination
  * Can differentiate croissant, baguette, and other objects
* **Limitations:**

  * Less precise motion compared to ACT

VLA models were used to **evaluate object selection and grounding**, not as a combined controller with ACT.

---

## Important Clarification

> **ACT and π0 / SmolVLA were not combined into a single multi-stage or hierarchical policy.**

They were:

* Trained independently
* Evaluated independently
* Compared on the same robotic task

---

## Missions

### Mission 1 – Preliminary Task

A simple pick-and-place task used to:

* Validate the LeRobot pipeline
* Test data recording and inference
* Calibrate the robot and cameras

**Mission 1 Artifacts:**

* 📦 Dataset:
  [https://huggingface.co/datasets/sakemyali/mission1-2](https://huggingface.co/datasets/sakemyali/mission1-2)
* 🤖 Model (ACT):
  [https://huggingface.co/sakemyali/try2](https://huggingface.co/sakemyali/try2)

---

### Mission 2 – Coffee & Croissant Manipulation

## Submission Details

### 1. Mission Description

**Real-world motivation:**
Household and assistive robots must safely manipulate everyday food items while understanding *what* to pick and *what to ignore*. Tasks such as serving food, handing objects to humans, or interacting with fragile items require a combination of **precise manipulation**, **object awareness**, and **robust execution in unstructured environments**.

Our robot autonomously performs **three distinct tasks**, depending on the object detected in the scene.

---

#### 🥐 Task 1: Croissant Interaction

When a **croissant** is detected, the robot:

- Detects and picks the **croissant**
- Dips it carefully into a **cup of coffee**
- Releases the croissant safely after dipping

---

#### 🥖 Task 2: Baguette Handover

When a **baguette** is detected, the robot:

- Detects and picks the **baguette**
- Hands it over to a human in a safe and controlled manner

---

#### 🚫 Task 3: Non-Target / Forbidden Object Handling

When a **non-target or unknown object** is detected, the robot adapts its behavior as follows:

- If the object is **unknown but not explicitly forbidden**, the robot:
  - Picks up the object
  - Places it back down safely

- If the object is a **forbidden item** (e.g., medicine), the robot:
  - Picks up the object
  - Performs a clear **“no” gesture** to indicate refusal
  - Places the object back down safely


With prior experience building classical manipulation pipelines, this project represents a transition toward **learning-based robotic control**, relying on data-driven policies trained from real demonstrations.

---

### 2. Creativity

* **Yes/No object acknowledgment**
  The robot responds semantically to objects:

  * Performs actions and signals “yes” for target objects (croissant, baguette)
  * Refuses and signals “no” for forbidden objects (doliprane)

* **Movement repetition**
  Each action is performed twice during training to:

  * Reinforce learning of each sub-action (pick, dip, handover)
  * Improve recovery from disturbances or minor errors

* **High-quality teleoperation demonstrations**
  We carefully teleoperated the SO-101 robot in regions of high manipulability, producing demonstrations that are smooth, realistic, and reliable:

  * Smooth trajectories with minimal abrupt motions
  * Natural grasping motions that preserve object integrity
  * Fewer failed trials for higher-quality training data

* **Soft-object manipulation strategy**
  The croissant is delicate and deformable, so we implemented:

  * Controlled wrist orientation to match the croissant’s shape
  * Slow approach speeds to prevent slipping or deformation

* **Safe handover behavior**
  During baguette delivery:

  * Conservative joint limits prevent sudden or unsafe motions
  * Reduced velocity ensures human safety
  * Demonstrates reliable human-robot interaction

* **Multi-view perception setup (3 synchronized cameras)**

  * **Gripper view:** monitors fine manipulation and object contact
  * **Top view:** provides workspace context and tracks object positions
  * **Side view:** gives depth cues and ensures collision-free motion

* **Robustness to disturbances**
  Policies tolerate real-world variability, including:

  * Minor object shifts or slips
  * Partial occlusions
  * Lighting changes such as shadows or dim environments

* **Generalizability**
  Learned policies can handle unseen objects safely:

  * Correctly interacts with new objects (e.g., a pencil)
  * Adapts to new shapes and sizes with minimal extra demonstrations


---

### 3. Technical Implementation

#### Training

* **Policies (trained independently):**

  * **ACT (Action Chunking Transformers)** for manipulation execution
  * **Vision-Language-Action models (π0, SmolVLA)** for object selection and semantic grounding

* **Inputs:**

  * Multi-view RGB images
  * Robot joint positions

* **Outputs:**

  * Joint-level action commands (for pi0) or action chunks (for the other policies)

---

#### Teleoperation & Dataset Capture

* **Robot:** SO-101 follower / leader arm
* **Cameras:**

  * 3× USB RGB cameras
  * Resolution: 640×480
  * Frame rate: 30 FPS

The dataset follows the **LeRobot standard format** and is reusable for future tasks.

---

#### Scripts Included (`mission2/code`)

* `fix_arms_access_permission.sh`
* `calib_follower.sh`
* `calib_leader.sh`
* `record_teleop_data_640x480_30fps_3cams.sh`
* `inference_teleop_640x480_30fps_3cams.sh`

---

### 4. Inference & Evaluation

* Same real-world hardware setup used during training
* Fully autonomous execution after start signal
* No human intervention during task execution
* Evaluated across multiple trials and lighting conditions
---------------------add training plots ----------
---

### 5. Results

#### 1. Successful Full-Task Execution

The robot reliably completes:

* Croissant pick and dip
* Baguette pick and handover

across repeated trials as we can see in the following videos :
https://youtu.be/MDfwkfW8x8w?si=-MuDqL52tvdrs0zx
https://youtu.be/MDfwkfW8x8w?si=-MuDqL52tvdrs0zx

---

#### 2. Object Awareness & Filtering

* Correctly distinguishes croissant, baguette, and non-target objects
* Avoids forbidden items
* Remains idle when no target object is detected

https://youtu.be/CIm8Ewrc9b8?si=L_SJo0eBMjYwMhpv
https://youtu.be/CiShu3YnrM4?si=KXbAPqK_0l7VKrA6
---

#### 3. Robustness to Lighting Conditions

Performance remains stable under:

* Bright lighting
* Dim indoor lighting
* Partial shadows

https://youtu.be/IBOvxAOvIsY?si=4Eod8bOSUkmDugpW

---

#### 4. Failure Handling & Recovery

* If a grasp fails, the robot reattempts the action
* If the object slips, the policy recovers without reset
* Small disturbances do not cause task failure

https://youtu.be/HEasbXmw7Y0?si=KrEOIr6H_LYbrH5S

---

### 6. Ease of Use

* Generalizable to new objects with additional demonstrations
* Modular policy design using LeRobot
* Simple execution workflow:

  * **Data collection:** `./record_*.sh <dataset-name>`
  * **Training:** single LeRobot notebook
  * **Inference:** `./inference_*.sh`

---

### 7. Future Extensions

* Multi-object serving scenarios
* Integration of VLA for object selection + ACT for execution
* Adaptation to home assistance or café service environments


---
---

## Dataset

* Collected via **teleoperation**
* Multi-camera synchronized recordings
* Smooth and natural human demonstrations
* Compatible with LeRobot standard format

![Coffee & Croissant Robot](extras/Adobe%20Express%20-%20AA85F1EA-90CC-4826-9FE3-D07864121704.gif)


**Mission 2 Dataset:**

* 📦 [https://huggingface.co/datasets/sakemyali/m2set](https://huggingface.co/datasets/sakemyali/m2set)

---

## Trained Models

* **ACT (Imitation Learning):**

  * Learns manipulation trajectories
* **π0 / SmolVLA (VLA):**

  * Learns object-aware behavior via vision-language grounding

**Models:**

* 🤖ACT_v1 [https://huggingface.co/KACM/act_pi0-croissant-so101](https://huggingface.co/KACM/act_pi0-croissant-so101)

* 🤖ACT_v2 [https://huggingface.co/sakemyali/actm2_v2](https://huggingface.co/sakemyali/actm2_v2)

* 🤖smolVLA [https://huggingface.co/sakemyali/svlam2](https://huggingface.co/sakemyali/svlam2)

* 🤖pi0 [https://huggingface.co/sakemyali/p0m2](https://huggingface.co/sakemyali/p0m2)

---

## Repository Structure

```bash
AMD_Hackathon_Paris2025/
├── extras/
├── mission1/
│   └── code/
│       ├── calibrate_fol.sh
│       ├── calibrate_lead.sh
│       ├── cam_teleop.sh
│       ├── inference_m1.sh
│       ├── permission_arm.sh
│       ├── permission_cam.sh
│       ├── record_m1.sh
│       └── teleop.sh
├── mission2/
│   └── code/
│       ├── calibrate_fol.sh
│       ├── calibrate_lead.sh
│       ├── cam_teleop.sh
│       ├── inference-actm2v1.sh
│       ├── inference-actm2v2.sh
│       ├── inference-pi0m2.sh
│       ├── inference-smolvlam2.sh
│       ├── fix_arms_access_permission.sh
│       ├── permission_arm.sh
│       ├── permission_cam.sh
│       ├── record_m2.sh
│       ├── resume_record_m2.sh
│       └── teleop.sh
├── AMD_team42_tokyo/
│   ├── README.md
│   ├── mission1/
│   ├── mission2/
│   │   └── vdemo/
│   └── presentation/
├── DigitalLaws/
└── README.md
```

---

## How to Reproduce

### 1. Environment Setup

```bash
conda create -n lerobot python=3.10
conda activate lerobot
pip install lerobot
```

Install camera utilities:

```bash
sudo apt-get update
sudo apt-get install -y v4l-utils
```

---

### 2. Hugging Face Login

```bash
export HF_USER="your_username"
export HUGGINGFACE_TOKEN="hf_xxxxxxxxxxxx"
cd mission2/code
./login_huggingface.sh
```

---

### 3. Fix Serial Permissions

```bash
./fix_arms_access_permission.sh
```

---

### 4. Calibrate the Arms

```bash
./calib_follower.sh
./calib_leader.sh
```

---

### 5. Record Teleoperation Data

```bash
./record_teleop_data_640x480_30fps_3cams.sh croissant-dipping-so101-v1
```

---

### 6. Train Policies

* Use LeRobot notebooks
* Train **ACT** and **π0 / SmolVLA** independently on the same dataset

---

### 7. Run Inference

```bash
./inference_teleop_640x480_30fps_3cams.sh
```

---

## Results

* ✅ Successful croissant dipping
* ✅ Safe baguette handover
* ✅ Robust object discrimination
* ✅ Stable performance under different lighting conditions

------------------Add videos + training plots -----------------

---

## Limitations & Future Work

* ACT lacks semantic object understanding
* VLA models lack high-precision control
* Future work could combine:

  * VLA for object selection
  * ACT for motion execution
* Extend to more objects and tasks

---

## Conclusion

This project demonstrates how **different policy families** can solve complementary aspects of a real-world manipulation problem.

By evaluating **ACT and Vision-Language-Action models independently**, we highlight their respective strengths and limitations in a practical robotic scenario.

---

## Acknowledgements

* AMD Robotics Hackathon 2025
* LeRobot framework
* Hugging Face Datasets & Models

---


