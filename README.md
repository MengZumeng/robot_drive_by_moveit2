# robot_drive_by_moveit2
this repository created for studing Moveit2  

THE FIRST COMMIT

1.通过urdf_tutorial 包提供的示例节点或工具来加载并可视化 URDF 文件
ros2 launch urdf_tutorial display.launch.py model:=/home/mengzumeng/Repo_Lib/robot_drive_by_moveit2/src/my_robot_description/urdf/my_robot.urdf.xacro

2.rviz配置文件可以在rviz启动时指定.rviz文件作为配置。

3.rqt_graph 工具来可视化显示当前节点与话题的订阅/发布关系
ros2 run rqt_graph rqt_graph


THE SECOND COMMIT

1.完成URDF碰撞属性添加

2.完成moveit config添加

3.尝试在docker中运行，后续为该仓库添加一镜像文件

4.在rviz中进行moveit config测试