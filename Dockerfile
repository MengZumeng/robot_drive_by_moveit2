# 基础镜像：MoveIt 2 Humble 官方镜像
FROM moveit/moveit2:humble-release

# 维护者信息（可选）
LABEL maintainer="mengzumeng"

# 配置环境变量（确保 ROS 环境自动加载）
ENV ROS_DISTRO=humble
ENV ROS_ROOT=/opt/ros/$ROS_DISTRO
ENV PATH=$ROS_ROOT/bin:$PATH
ENV LD_LIBRARY_PATH=$ROS_ROOT/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH=$ROS_ROOT/lib/python3.10/site-packages:$PYTHONPATH

# 安装 example_interfaces 功能包
RUN sudo apt update && \
    sudo apt install -y ros-humble-example-interfaces && \
    # 清理缓存，减小镜像体积
    sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

# 启动时默认进入 bash 终端（与原镜像保持一致）
CMD ["/bin/bash"]