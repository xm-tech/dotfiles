# My personal dotfiles

![overview](img/overview.png "overview")

## 安装与使用

### 前提条件

```txt
推荐在 macOS 上使用，其他系统需要手动安装外部软件和插件
```

### 在旧机器上（可选）

生成 Brewfile

```shell
make bundle
```

### 在新机器上

```shell
# 安装所有 brew 依赖（可选）
make bundle_install

# 将配置文件复制到相应位置
make install
```
