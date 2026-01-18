
# 艾利特 CS625 机械臂 ROS 2 项目 (Elite CS625 ROS 2 Project)

本项目是用于控制和可视化艾利特（Elite）CS625协作机器人的ROS 2工作空间。该项目基于官方驱动，并进行了多项稳定性和易用性优化。

---

## 1. 系统环境与配置 (System Environment)

以下是本项目成功运行并验证的关键环境配置。

| 项目 (Item)             | 版本 / 配置 (Version / Configuration)              | 备注 (Notes)                                   |
| ----------------------- | ---------------------------------------------------- | ---------------------------------------------- |
| **操作系统 (OS)**       | Ubuntu 22.04 LTS                                     | 在 VMware 虚拟机中运行                         |
| **ROS 2 版本**          | Jazzy Jalisco (Desktop Install)                      |                                                |
| **机器人型号 (Robot)**    | Elite CS625                                          |                                                |
| **虚拟机软件 (VM)**     | VMware Virtual Platform                              |                                                |
| **Git 客户端**          | `git version 2.34.1` 或更高                          |                                                |

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

- **验证方法**:
  - 在Ubuntu终端中，使用 `ping 192.168.1.200` 命令，必须能收到回复 (0% packet loss)。

---

## 3. 安装与部署 (Installation)

1.  **克隆仓库**
    ```bash
    cd ~
    git clone https://github.com/addission/elite-cs625-ros2-project.git elite_ros_ws
    ```

2.  **安装项目依赖**
    ```bash
    cd ~/elite_ros_ws
    sudo apt update
    rosdep install --from-paths src -y --ignore-src
    ```

3.  **编译工作空间**
    ```bash
    cd ~/elite_ros_ws
    colcon build
    ```

4.  **配置桌面启动器**
    将 `desktop_files/` 目录下的 `.desktop` 文件复制到桌面，并赋予其执行权限。
    ```bash
    cp ~/elite_ros_ws/desktop_files/CS625机器人启动器.desktop ~/Desktop/
    chmod +x ~/Desktop/CS625机器人启动器.desktop
    ```

---

## 4. 使用方法 (Usage)

直接双击桌面上的 **"CS625机器人启动器"** 图标即可启动整个系统。

该启动器 (`cs625_launcher.sh`) 经过特殊优化，会自动完成以下操作：
1.  **自动清理**: 强制杀死所有旧的ROS节点，解决“失败后无法重连”的问题。
2.  **延时等待**: 在启动前等待5秒，确保机器人控制器服务已完全就绪，提高首次连接成功率。
3.  **加载环境并启动**: 自动加载ROS环境并执行 `ros2 launch` 命令。

---

## 5. 已解决的关键问题 (Troubleshooting & Fixes)

本文档记录了在部署过程中遇到的主要问题及其解决方案，这些方案已集成到代码和脚本中。

#### 问题1: 首次连接失败后，不重启系统就再也无法成功连接。
- **原因**: 程序异常退出后，ROS节点进程未被完全杀死，导致网络端口被持续占用。
- **解决方案**: 在启动脚本 `cs625_launcher.sh` 的最开始加入了 `killall -9 ...` 和 `ros2 daemon restart` 命令，在每次启动前强制清理环境。

#### 问题2: 偶尔出现 `Broken pipe` 或 `Connect fail` 错误。
- **原因**: 电脑端的ROS驱动启动速度过快，而机器人控制器的网络服务尚未完全准备好接受连接。
- **解决方案**: 在启动脚本 `cs625_launcher.sh` 的 `ros2 launch` 命令前增加了 `sleep 5` 的延时。

#### 问题3: `git push` 时认证失败，提示不支持密码认证。
- **原因**: GitHub不再支持通过密码进行Git操作的认证。
- **解决方案**: 在GitHub网站生成了一个 **Personal Access Token (PAT)**，在 `git push` 时，使用该Token代替密码进行认证。

---

## 6. 备份策略 (Backup Strategy)

- **云端版本控制 (推荐)**: 本项目已使用 Git 进行版本控制，并托管在 GitHub。核心源代码和配置文件都已上传。这是恢复项目的首选方式。
- **本地完整备份**: 曾使用 `tar` 命令创建了包含编译产物 (`build`, `install`) 在内的完整本地备份 (`elite_ros_ws_backup_xxxx-xx-xx.tar.gz`)，可用于快速恢复整个工作目录。






### 验证步骤

请在您的Ubuntu终端中按照以下步骤操作：

**第1步：进入主目录**

我们将在一个新的位置进行测试，以免与您现有的工作区混淆。
```bash
cd ~  # 回到主目录 ( /home/yff )
```

**第2步：将GitHub仓库克隆到一个新文件夹中**

`git clone` 命令会从GitHub上下载整个项目。我们把它下载到 `elite_ros_ws_test` 这个新文件夹里。
```bash
git clone https://github.com/addission/elite-cs625-ros2-project.git elite_ros_ws_test
```
执行这个命令后，您会看到类似下面的下载进度：
```
Cloning into 'elite_ros_ws_test'...
remote: Enumerating objects: ..., done.
remote: Counting objects: 100% (...), done.
remote: Compressing objects: 100% (...), done.
remote: Total ... (delta ...), reused ... (delta ...), pack-reused 0
Receiving objects: 100% (...), done.
Resolving deltas: 100% (...), done.
```
这会在您的主目录下创建一个名为 `elite_ros_ws_test` 的新文件夹。

**第3步：进入新的项目文件夹并编译**

现在，我们进入这个全新的工作区，并像一个正常ROS 2项目一样编译它。

```bash
# 进入新克隆下来的工作区
cd ~/elite_ros_ws_test

# 使用 colcon build 进行编译 (这个过程需要一点时间)
colcon build
```
**期望结果**：编译过程应该会顺利进行，最终显示 `Finished <<< ...` 并且没有任何红色报错。如果能成功编译，说明您的源代码、`package.xml` 和 `CMakeLists.txt` 文件都已正确备份。

**第4步：运行您的启动脚本来验证**

编译成功后，我们来运行项目，看看机器人是否能正常启动和控制。这会验证您的 `cs625_launcher.sh` 脚本和 `src` 目录下的代码逻辑是否完整。

```bash
# 运行我们之前编写的启动器脚本
./cs625_launcher.sh
```

