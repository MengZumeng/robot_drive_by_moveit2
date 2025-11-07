以下是完整的 `README.md` 文件内容，可直接复制保存为 `README.md` 并提交到仓库：

```markdown
# robot_drive_by_moveit2

![MoveIt2](https://moveit.ros.org/assets/logo/moveit_logo-black.png)

## 项目目的
本仓库旨在学习和实践 **MoveIt2 运动规划框架**，通过搭建机器人模型、配置 MoveIt2 核心组件及编写控制逻辑，实现机器人的运动规划与实时控制。

项目提供从机器人模型描述、MoveIt2 配置到控制代码的完整示例，适用于 ROS 2 开发者、机器人运动规划学习者，可作为入门实践参考或二次开发基础。

## 主要内容
| 功能包名称               | 核心作用                                                                 |
|--------------------------|--------------------------------------------------------------------------|
| `my_robot_description`   | 机器人模型定义（URDF/Xacro 格式），包含碰撞属性、可视化配置及模型展示 launch 文件 |
| `my_robot_moveit_config` | MoveIt2 核心配置，含运动学参数、关节限制、控制器配置、move_group 启动文件       |
| `my_robot_commander_cpp` | C++ 控制示例代码，支持目标位姿规划、关节角度控制、笛卡尔路径规划等功能         |
| `my_robot_bringup`       | 系统整合启动包，提供一键启动机器人描述、控制器、MoveIt2 节点的 launch 文件     |
| `my_robot_interfaces`    | 自定义 ROS 2 消息类型，用于传递机器人位姿控制指令（如坐标、姿态参数）           |

核心特性：
- 支持多种运动规划模式（关节空间规划、笛卡尔空间规划）
- 提供 ROS 2 话题接口，可外部发送控制指令
- 包含 RViz 可视化配置，实时查看机器人状态与规划路径
- 兼容 MoveIt2 原生工具链，支持手动规划与代码控制双模式

## 环境搭建
### 前置依赖
- 操作系统：Ubuntu 22.04 LTS（兼容 ROS 2 Humble）
- ROS 2 版本：Humble（推荐）
- 核心依赖：MoveIt2、Joint State Publisher、Controller Manager、Xacro

### 安装步骤
1. **安装 ROS 2 与 MoveIt2**
   参考 [ROS 2 官方安装指南](https://docs.ros.org/en/humble/Installation.html) 完成 ROS 2 Humble 安装，再安装 MoveIt2 依赖：
   ```bash
   sudo apt update && sudo apt install -y ros-humble-moveit
   ```

2. **安装其他依赖包**
   ```bash
   sudo apt install -y \
     ros-humble-joint-state-publisher-gui \
     ros-humble-controller-manager \
     ros-humble-xacro \
     ros-humble-example-interfaces \
     python3-colcon-common-extensions
   ```

3. **构建工作空间**
   ```bash
   # 创建工作空间（若已存在可跳过）
   mkdir -p ~/moveit2_ws/src && cd ~/moveit2_ws/src

   # 克隆本仓库
   git clone https://github.com/MengZumeng/robot_drive_by_moveit2.git

   # 编译工作空间（--symlink-install 支持文件软链接，修改代码无需重新编译）
   cd ~/moveit2_ws
   colcon build --symlink-install

   # 加载环境变量（每次新终端启动需执行，或添加到 ~/.bashrc 永久生效）
   source install/setup.bash
   ```

### Docker 快速部署（推荐）
若不想手动配置环境，可通过 Docker 一键启动（需先安装 Docker）：
```bash
# 克隆仓库
git clone https://github.com/MengZumeng/robot_drive_by_moveit2.git && cd robot_drive_by_moveit2

# 构建 Docker 镜像（基于 MoveIt2 官方镜像，预安装依赖）
sudo docker build -t my_moveit2_robot:humble -f Dockerfile .

# 运行容器（支持 GUI 显示，挂载代码目录）
sudo docker run -it \
  --env="DISPLAY=$DISPLAY" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$PWD:/root/robot_ws/src/robot_drive_by_moveit2:rw" \
  --privileged \
  my_moveit2_robot:humble /bin/bash

# 容器内编译并启动（后续步骤同「样例执行」）
cd ~/robot_ws && colcon build --symlink-install && source install/setup.bash
```

## 样例执行
### 1. 可视化机器人模型
验证机器人模型是否正常加载：
```bash
ros2 launch urdf_tutorial display.launch.py model:=$(ros2 pkg prefix my_robot_description --share)/urdf/my_robot.urdf.xacro
```
- 效果：启动 RViz 并显示机器人模型，可通过「Joint State Publisher GUI」滑动条手动调整关节角度。

### 2. 启动完整 MoveIt2 系统
一键启动机器人描述、控制器、MoveIt2 规划节点：
```bash
ros2 launch my_robot_bringup my_robot.launch.xml
```
- 效果：启动 RViz（加载 MoveIt2 配置）、move_group 节点、控制器管理器，可在 RViz 中通过「Motion Planning」面板手动规划运动。

### 3. 运行代码控制示例
#### 3.1 基础运动测试
在新终端中运行预定义的运动控制节点（需先启动完整 MoveIt2 系统）：
```bash
source ~/moveit2_ws/install/setup.bash
ros2 run my_robot_commander_cpp test_moveit
```
- 功能：演示机器人手臂从初始位姿到目标位姿的规划与执行，包含关节空间规划和笛卡尔路径规划。

#### 3.2 话题指令控制
运行指挥官节点，通过 ROS 2 话题发送控制指令：
```bash
# 启动指挥官节点
ros2 run my_robot_commander_cpp commander
```

在新终端中发送以下指令测试：
- **控制夹爪开合**：
  ```bash
  ros2 topic pub /open_gripper std_msgs/msg/Bool "{data: true}"  # 打开夹爪
  ros2 topic pub /open_gripper std_msgs/msg/Bool "{data: false}" # 关闭夹爪
  ```

- **发送关节角度目标**（6个关节角度，范围：-π~π）：
  ```bash
  ros2 topic pub /joint_command std_msgs/msg/Float64MultiArray "{data: [0.0, 0.5, -0.5, 0.0, 0.5, -0.5]}"
  ```

- **发送位姿目标**（x,y,z 坐标 + roll,pitch,yaw 姿态，cartesian 表示是否使用笛卡尔路径）：
  ```bash
  ros2 topic pub /pose_command my_robot_interfaces/msg/PoseCommand "{x: 0.3, y: 0.0, z: 0.4, roll: 0.0, pitch: 0.0, yaw: 0.0, cartesian: false}"
  ```

### 4. 查看系统拓扑
可视化节点与话题的订阅/发布关系：
```bash
ros2 run rqt_graph rqt_graph
```

## 注意事项
1. 若 RViz 显示异常（如无机器人模型），检查环境变量是否加载：`echo $ROS_PACKAGE_PATH`，确保工作空间路径已包含。
2. 编译失败时，尝试删除 `build`、`install`、`log` 目录后重新编译：`rm -rf build install log && colcon build --symlink-install`。
3. Docker 中 GUI 显示失败，需在主机执行：`xhost +`（临时允许容器访问显示器）。
4. 自定义机器人模型后，需重新生成 MoveIt2 配置：`ros2 launch moveit_setup_assistant setup_assistant.launch.py`。

## 参考资料
- [MoveIt2 官方文档](https://moveit.picknik.ai/humble/index.html)
- [ROS 2 Humble 官方教程](https://docs.ros.org/en/humble/Tutorials.html)
- [URDF 机器人模型描述指南](https://docs.ros.org/en/humble/Tutorials/Intermediate/URDF/URDF-Main.html)
```
