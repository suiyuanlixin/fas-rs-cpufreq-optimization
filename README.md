> **[README_EN.md](README_EN.md)**

# **fas-rs-cpufreq-optimization**

## **模块简介**
- 一个 api v4 的 [fas-rs](https://github.com/shadow3aaa/fas-rs) 频率优化插件
- **需配合 fas-rs v4.3.0 及以上版本使用**
- 已适配 fas-rs-mod ，无需且 **禁止** 手动移动插件
- ~~搭配 fas-rs-pro-max 最新版可开启实验性功能~~（已弃用）
- 模块拥有较为完善的冲突检测系统，若检测到冲突请卸载冲突模块
- 建议搭配 **[Asoulopt](https://github.com/nakixii/Magisk_AsoulOpt)** 或 [Thread-opt](https://github.com/reigadegr/thread-opt) 或 核心分配 等（选其一）
- Action 按钮：选择切换 [GameTurbo 模式](#gameturbo-模式)

## **支持的处理器**
- 骁龙 8 Elite
- 骁龙 8 Gen 3
- 骁龙 7+ Gen 3
- 骁龙 8 Gen 2
- 骁龙 8s Gen 3
- 骁龙 7+ Gen 2
- 骁龙 8 Gen 1
- 骁龙 8+ Gen 1
- **其余处理器将使用默认配置**

## **支持的游戏**
- 原神
- Genshin Impact
- 王者荣耀
- Honor of Kings
- 火影忍者
- 和平精英
- PUBG Mobile
- 鸣潮
- 穿越火线-枪战王者
- 时空猎人
- 英雄联盟手游
- QQ飞车
- 永劫无间
- 光遇
- 绝区零
- Zenless Zone Zero
- 金铲铲之战
- 第五人格
- 使命召唤手游
- 三国杀
- 明日方舟
- 暗区突围
- **其余游戏将使用默认配置**

## **GameTurbo 模式**
- 让 CPU 保持在较高频率
- 关闭 fas-rs 的核心温控

## **申请适配**
1. 确认游戏在当前处理器没有被此插件适配
2. 确认搭配 Asoul-opt 等线程放置模块使用
3. 开一个 issue：Scene 帧率记图及游戏包名
