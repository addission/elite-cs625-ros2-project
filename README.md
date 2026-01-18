
# 艾利特 CS625 机械臂 ROS 2 项目 (Elite CS625 ROS 2 Project)

本项目是用于控制和可视化艾利特（Elite）CS625协作机器人的ROS 2工作空间。该项目基于官方驱动，并进行了多项稳定性和易用性优化，以解决在实际部署中遇到的连接和鲁棒性问题。

---

## 1. 系统环境与配置 (System Environment)

以下是本项目成功运行并验证的关键环境配置。

| 项目 (Item)             | 版本 / 配置 (Version / Configuration)              | 备注 (Notes)                                   |
| ----------------------- | ---------------------------------------------------- | ---------------------------------------------- |
| **操作系统 (OS)**       | Ubuntu 22.04 LTS                                     | 在 VMware 虚拟机中运行                         |
| **ROS 2 版本**          | Jazzy Jalisco (Desktop Install)                      |                                                |
| **机器人型号 (Robot)**    | Elite CS625                                          |                                                |
| **虚拟机软件 (VM)**     | VMware Virtual Platform                              |                                                |
| **Git 客户端**          | `git version 2.34.1` 或更高                          | 用于版本控制                                   |

---

## 2. 网络设置 (Network Configuration)

网络配置是本项目正常运行的**最关键环节**。

- **虚拟机网络模式**: **桥接模式 (Bridged Mode)**
  - 必须设置为桥接模式，让虚拟机获得与物理机和机器人处于同一网段的独立IP地址。

- **IP 地址分配**:
  - **机器人控制器IP**: `192.168.1.200` (必须为静态IP)
  - **电脑/虚拟机IP**: `192.168.1.102` (或`192.168.1.xxx`网段内的任何其他地址)
  - **子网掩码**: `255.255.255.0` (即 `/24`)

- **物理连接**:
  - 使用网线将装有虚拟机的电脑与机器人控制器直接连接，或连接到同一台路由器/交换机下。

- **连接验证**:
  - 在Ubuntu终端中，使用 `ping 192.168.1.200` 命令，必须能收到回复 (0% packet loss)，证明网络物理连接和IP设置正确。

---

## 3. 安装与部署 (Installation & Deployment)

请按照以下步骤从零开始部署本项目。

1.  **克隆本仓库**
    ```bash
    cd ~
    git clone https://github.com/addission/elite-cs625-ros2-project.git elite_ros_ws
    ```

2.  **安装依赖并编译**
    ```bash
    # 进入工作空间目录
    cd ~/elite_ros_ws

    # 自动安装所有依赖包
    sudo apt update
    rosdep install --from-paths src -y --ignore-src

    # 编译工作空间
    colcon build
    ```

3.  **配置桌面启动器**
    为了方便使用，可以将项目内提供的快捷方式复制到桌面。
    ```bash
    cp ~/elite_ros_ws/desktop_files/CS625机器人启动器.desktop ~/Desktop/
    chmod +x ~/Desktop/CS625机器人启动器.desktop
    ```

---

## 4. 使用方法 (Usage)

完成安装部署后，直接双击桌面上的 **"CS625机器人启动器"** 图标即可启动整个系统。

该启动器 (`cs625_launcher.sh`) 经过特殊优化，会自动完成以下操作：
1.  **自动清理**: 强制杀死所有旧的ROS节点，解决“失败后无法重连”的问题。
2.  **延时等待**: 在启动前等待5秒，确保机器人控制器服务已完全就绪，提高首次连接成功率。
3.  **加载环境并启动**: 自动加载ROS环境并执行 `ros2 launch` 命令。
