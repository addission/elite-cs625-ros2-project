#!/bin/bash
# =======================================================
# ==    艾利特 CS625 机器人 ROS2 启动脚本 (智能稳定版)   ==
# ==    功能: 自动清理旧进程，解决无法重连问题        ==
# =======================================================

echo "--- [步骤 1/3] 正在自动清理旧的ROS进程..."
# 强制杀死所有相关的旧进程，解决“无法重连”的问题
# -q 安静模式，-w 等待进程结束。 2>/dev/null 隐藏错误信息
killall -q -w -9 eli_ros2_control_node rviz2 spawner controller_stopper_node robot_state_publisher eli_components_loader 2>/dev/null

# 重置ROS 2守护进程，解决潜在的通信异常
ros2 daemon stop > /dev/null 2>&1
ros2 daemon start > /dev/null 2>&1

echo "--- 清理完成。等待系统资源释放..."
sleep 2 # 短暂等待，确保端口被完全释放

# --- 分割线 ---

echo ""
echo "--- [步骤 2/3] 正在加载ROS2工作空间环境..."
source /opt/ros/jazzy/setup.bash
source ~/elite_ros_ws/install/setup.bash
echo "--- 环境加载成功！"
echo ""

# --- 分割线 ---

echo "--- [步骤 3/3] 正在启动机器人驱动与RViz..."

# 保留您添加的延时，这是一个好习惯
echo "--- 等待5秒，确保机器人控制器已完全准备就绪..."
sleep 5

echo "--- 使用的参数:"
echo "    - 机器人IP: 192.168.1.200"
echo "    - 机器人型号: cs625"
echo "    - 机器人系列: cs625"
echo ""

# 执行最终的启动命令
ros2 launch eli_cs_robot_driver elite_control.launch.py robot_ip:=192.168.1.200 model:=cs625 cs_type:=cs625

# --- 脚本执行结束 ---

echo ""
echo "---------------------------------------------------------"
echo "--- 启动脚本已执行完毕。"
echo "--- 如果程序异常退出，可直接再次双击本启动器重试。"
echo "--- 按下 [Enter] 键即可关闭此终端窗口。"
echo "---------------------------------------------------------"
read

