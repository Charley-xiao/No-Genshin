# CS207 2023 Fall Project: Mini Piano

小组成员：何家阳、邱天润、肖淇文

> 源码放在 GitHub 项目上，将会在项目结束后开源，其链接为：[Charley-xiao/No-Genshin: No Genshin Minipiano (github.com)](https://github.com/Charley-xiao/No-Genshin)

## 开发日程安排和实施情况
### 1.团队分工及贡献占比：
何家阳：学习模式功能的构建与实现，自动模式和用户系统的实现，曲库的建立，项目视频的录制完成，项目文档的编写。

邱天润：主模块与全局控制的构建与实现，键位调整，VGA显示，LED灯管显示，项目视频的录制完成，项目文档的编写。

肖淇文：主模块与全局控制的构建与实现，手动模式和自动模式的实现，LED灯管显示，项目文档的编写。

**贡献百分比**相同，为**1:1:1**。

### 2. 开发计划日程安排
    1.项目需求分析与代码初步构建 2023/11/17~2023/11/22
    
    2.项目代码搭建，完成手动模式和自动模式 2023/11/23~2023/11/25
    
    3.学习模式实现 2023/11/26~2023/12/12
    
    4.完善功能，完成项目文档和视频工作 2023/12/13~2023/12/24
### 3. 实施情况
    1.第一次小组讨论，分析项目框架与状态图 2023/11/17
    
    2.第二次小组讨论，已完成项目代码搭建，完成手动（自由）模式和自动模式 2023/11/23~2023/11/25
    
    3.第三次小组讨论，实现七段数码管显示 2023/11/26~2023/12/2
    
    4.第四次小组讨论，VGA框架基础实现 2023/12/3~2023/12/6
    
    5.学习模式实现 2023/12/6~2023/12/12
    
    6.VGA功能实现 2023/12/13
    
    7.第五次小组讨论，完善功能，在答辩前完成功能和文档、视频的制作 2023/12/13~2023/12/25

### 4.心得
  由于各名成员学习任务重，小组采取不断集中完成模块化设计的方式逐步实现了整个项目，并在项目后期进行更详尽的分工，给予更多时间完成项目。经过整个项目的编写，我们对硬件语言有了更清晰的认识，积累了小组合作的优良经验，使每一位小组成员都受益匪浅。
## 系统功能列表与使用说明
**本项目实现了一个由EGO1控制的电子琴学习机，并具有以下功能：**

1. 根据拨码开关切换模式（00: 调整模式，01: 学习模式，10: 自动模式，11: 自由模式）。

2. 在自由模式下，可以通过拨动拨码开关演奏对应的音符，可以通过设置的拨码开关改变当前的八度（共三个八度）,并可以通过按钮改变升降调（00: 低，01: 中，10: 高）。

3. 在自动模式下，自动播放曲库中的歌曲，曲库中初始设置有4首歌曲，实现了播放不同长度的音符，歌曲会循环播放，可以通过按钮来切换歌曲或更换曲调，或者暂停/重启播放，在七段数码管展现当前歌曲编号，音符对应的led灯亮起，在VGA实现当前歌曲名称和演奏的音符。

4. 在学习模式下，可以通过按钮切换曲目和当前账号（演奏时不能更改账号），用户需要拨动led灯对应的拨码开关来实现音符的播放，当音符播放对应的时间后，会转到下一个音符，用户需要将拨码开关拨回后继续演奏。演奏每个音符获得的分数会由用户拨动拨码开关对应的间隔时间来分级，演奏过程中会实时显示分数，演奏完成后会显示评级和分数并更新当前用户的最高评级（S，A，B，C 四档）。

5. 在调整模式下，会依次播放七个音符，依次选择对应的音符，就可以改变它们的默认对应关系。

**显示模块**包括led灯的显示（演奏音符）、七段数码管的显示（歌曲编号，账户id，分数，评级），VGA的显示（歌曲名称，账户id，分数，评级）。

**输入输出**介绍如下：

![image-20231226123909338](Project.assets/image-20231226123909338.png)

**顶层端口**如下：
| Port name   | Direction | Type       | Description          |
| ----------- | --------- | ---------- | -------------------- |
| clk         | input     | wire       | 总时钟信号           |
| sel         | input     | wire [6:0] | 选择的音符           |
| octave      | input     | wire [1:0] | 音高选择             |
| _mode       | input     | wire [1:0] | 模式选择             |
| butscale    | input     | wire       | 换音调               |
| up          | input     | wire       | 切换之后一首曲       |
| down        | input     | wire       | 切换之前一首曲       |
| user_switch | input     | wire       | 切换用户             |
| showaccount | input     | wire       | 显示用户信息         |
| speaker     | output    | wire       | 外放喇叭             |
| md          | output    | wire       | 调整音量             |
| led         | output    | [6:0]      | LED 灯管             |
| seg_out0    | output    | [7:0]      | 第一组七段数码管内容 |
| tub_sel0    | output    | [3:0]      | 第一组七段数码管控制 |
| seg_out1    | output    | [7:0]      | 第二组七段数码管内容 |
| tub_sel1    | output    | [3:0]      | 第二组七段数码管控制 |
| red         | output    | [3:0]      | VGA：红色信号        |
| green       | output    | [3:0]      | VGA：绿色信号        |
| blue        | output    | [3:0]      | VGA：蓝色信号        |
| hs          | output    | wire       | VGA：横向扫描波      |
| vs          | output    | wire       | VGA：纵向扫描波      |

并可以用下图展示：

<img src="Project.assets/image-20231224232337530.png" alt="image-20231224232337530" style="zoom:50%;" />

## 系统结构说明

本项目的结构可由下面的流程图说明，其中，每个模块的功能在后面的子模块功能说明中有详细的介绍。

![](Project.assets/flowchart.png)

## 子模块功能说明

### 顶层模块：MiniPiano

![b4aae19581b86de61e935bb7efea467a](Project.assets/b4aae19581b86de61e935bb7efea467a.png)

内部直接实现子模块实例：

- `hex_to_decimal`，实现从会被默认转为16进制的二进制到每四位二进制代表一个十进制数字的转换器。
- `light_val_controller`，实现对七段数码管所显示内容的统一控制。
- `light_7seg_manager`，实现对七段数码管的直接操作。
- `debouncer`，实现按键消抖。
- `sel_alter_manager`，实现选择音符的重新安排（调整模式）的设置和实际使用。
- `buzzer`，实现不同音高发音的蜂鸣器模块。
- `vga`，VGA显示的控制模块，实现当前乐曲、当前模式和当前音符的显示。
- `InController`，手动模式的控制模块。
- `AutoController`，自动模式的控制模块。
- `LearnController`，学习模式的控制模块。

### 子模块： hex_to_decimal

一般来说，将一个二进制数组每四位转为一个数，将表现为16进制。这一模块通过数字处理实现每四位代表一个10进制数字。

<img src="Project.assets/image-20231225001812507.png" alt="image-20231225001812507" style="zoom:50%;" />

| Port name | Direction | Type   | Description                                               |
| --------- | --------- | ------ | --------------------------------------------------------- |
| data      | input     | [9:0]  | 输入的二进制数，最多10位                                  |
| out       | output    | [11:0] | 输出的表示10进制数的二进制表示，最多表现3位数因此有12位长 |

### 子模块：light_val_controller

这一模块根据不同的模式，解析多种输入，并输出带有格式的字符串供7段数码管模块可以直接显示。

<img src="Project.assets/image-20231225002120204.png" alt="image-20231225002120204" style="zoom:50%;" />

| Port name      | Direction | Type   | Description                              |
| -------------- | --------- | ------ | ---------------------------------------- |
| _mode          | input     | [1:0]  | 当前所处模式                             |
| num            | input     | [6:0]  | （自动/学习模式）当前曲子编号            |
| score          | input     | [11:0] | （学习模式）当前分数                     |
| cur_note_alter | input     | [2:0]  | （调整模式）当前在调整的对应音符         |
| grade          | input     | [1:0]  | （学习模式）评级                         |
| user_id        | input     | [7:0]  | （学习模式）用户ID                       |
| val_7seg       | output    | [31:0] | 输出的32位二进制，用于在七段数码管上输出 |

### 子模块：light_7seg_manager

直接显示`light_val_controller`模块中输出的`val_7seg`，按照FPGA要求分为两组八个七段数码管，通过极短时间内逐个设置，实现所有七段数码管的点亮。

<img src="Project.assets/image-20231225002605175.png" alt="image-20231225002605175" style="zoom:50%;" />

| Port name | Direction | Type   | Description                |
| --------- | --------- | ------ | -------------------------- |
| val       | input     | [31:0] | 输入的32位二进制，用于输出 |
| rst       | input     |        | 重置符号                   |
| clk       | input     |        | 时钟信号                   |
| _mode     | input     | [1:0]  | 当前所处模式               |
| seg_out0  | output    | [7:0]  | 第一组七段数码管内容       |
| tub_sel0  | output    | [3:0]  | 第一组七段数码管控制       |
| seg_out1  | output    | [7:0]  | 第二组七段数码管内容       |
| tub_sel1  | output    | [3:0]  | 第一组七段数码管控制       |

 内部实现了子模块：

- `light_7seg_ego`用于操作其中一个灯管，共两组实例，每个实例轮流操作一组中的四个七段数码管。

### 子模块：light_7seg_ego

操作其中一个灯管，根据输入在转译为7段数码管的数字。

<img src="Project.assets/image-20231225224605933.png" alt="image-20231225224605933" style="zoom:50%;" />


| Port name | Direction | Type  | Description         |
| --------- | --------- | ----- | ------------------- |
| sw        | input     | [3:0] | 输入的对应信息      |
| rst       | input     |       | 重置信号            |
| _mode     | input     | [1:0] | 所处模式            |
| seg_out   | output    | [7:0] | 输出的7段数码管信号 |

### 子模块：debouncer

这个模块实现了按键消抖，在`DEB_DELAY`时钟周期中只响应一次操作结果。

## <img src="Project.assets/image-20231225222800879.png" alt="image-20231225222800879" style="zoom:50%;" />

| Port name | Direction | Type | Description        |
| --------- | --------- | ---- | ------------------ |
| clk       | input     |      | 时钟信号           |
| k_in      | input     |      | 输入的按键信号     |
| k_out     | output    | wire | 输出的消抖按键信号 |

### 子模块：sel_alter_manager

这个模块处理调整模式的设置，即依次播放7个音符，并记住所按下的对应拨码开关；以及设置完之后的处理，即所有的输入信号在这里变为解析过的`parsed_sel`信号。

<img src="Project.assets/image-20231225223606219.png" alt="image-20231225223606219" style="zoom:50%;" />

| Port name  | Direction | Type  | Description              |
| ---------- | --------- | ----- | ------------------------ |
| rset       | input     |       | 重置信号                 |
| clk        | input     | [1:0] | 时钟信号                 |
| mode       | input     | [6:0] | 当前模式，只在`00`时启动 |
| sel        | input     | [6:0] | 输入的原汁原味的音符     |
| parsed_sel | output    | [6:0] | 输出的解析过的音符       |
| note       | output    | [4:0] | 播放音符对应的音高       |
| cur_note   | output    | [2:0] | 当前正在播放的音符       |

### 子模块：buzzer

实现不同音调和音高的发声，以及对应LED的亮灭。

<img src="Project.assets/image-20231225224953760.png" alt="image-20231225224953760" style="zoom:50%;" />

| Port name | Direction | Type       | Description      |
| --------- | --------- | ---------- | ---------------- |
| play      | input     | wire       | 是否播放音符     |
| _mode     | input     | wire [1:0] | 所处模式         |
| clk       | input     | wire       | 时钟信号         |
| note      | input     | wire [4:0] | 所播放声音的音高 |
| scale     | input     | wire [2:0] | 设置升降调       |
| led       | output    | [6:0]      | 对应LED的亮灭    |
| speaker   | output    | wire       | 扬声器播放控制   |

### 子模块：vga

这个模块实现了VGA输出，可以分在两行显示当前模式、音符和歌曲名称。

<img src="Project.assets/image-20231225230904278.png" alt="image-20231225230904278" style="zoom:50%;" />

| Port name | Direction | Type  | Description      |
| --------- | --------- | ----- | ---------------- |
| clk       | input     |       | 时钟信号         |
| rst       | input     |       | 重置信号         |
| mode      | input     | [1:0] | 当前所处模式     |
| note      | input     | [4:0] | 所播放声音的音高 |
| num       | input     | [6:0] | 对应的歌曲对应ID |
| r         | output    | [3:0] | VGA的Red通道     |
| g         | output    | [3:0] | VGA的Green通道   |
| b         | output    | [3:0] | VGA的Blue通道    |
| hs        | output    |       | 横向扫描         |
| vs        | output    |       | 竖向扫描         |

实现了子模块：

- `state_data_control`，对所处在模式的解析。
- `note_data_control`，对当前音符的解析。
- `name_data_control`，对当前歌曲名称的解析。
- `char_set`，将字符解析为VGA点阵。

### 子模块：state_data_control

将当前模式信息解析为`char_set`模块可以直接处理的格式。

<img src="Project.assets/image-20231225231252541.png" alt="image-20231225231252541" style="zoom:50%;" />

| Port name | Direction | Type   | Description |
| --------- | --------- | ------ | ----------- |
| clk       | input     |        | 时钟信号    |
| rst       | input     |        | 重置信号    |
| mode      | input     | [1:0]  | 模式        |
| data      | output    | [35:0] | 输出的信号  |

### 子模块：note_data_control

将当前音符信息解析为`char_set`模块可以直接处理的格式（2位长）。

<img src="Project.assets/image-20231225231458450.png" alt="image-20231225231458450" style="zoom:50%;" />

| Port name | Direction | Type   | Description |
| --------- | --------- | ------ | ----------- |
| clk       | input     |        | 时钟信号    |
| rst       | input     |        | 重置信号    |
| mode      | input     | [1:0]  | 模式        |
| data      | output    | [11:0] | 输出的信号  |

### 子模块：name_data_control

将当前音频文件名信息解析为`char_set`模块可以直接处理的格式（10位长）。

<img src="Project.assets/image-20231225231754309.png" alt="image-20231225231754309" style="zoom:50%;" />

| Port name | Direction | Type   | Description |
| --------- | --------- | ------ | ----------- |
| clk       | input     |        | 时钟信号    |
| rst       | input     |        | 重置信号    |
| mode      | input     | [1:0]  | 模式        |
| data      | output    | [59:0] | 输出的信号  |

### 子模块：char_set

每个`char_set`模块将一个六位长字串解析为一个高为7格，宽为8格的点阵字符。

<img src="Project.assets/image-20231225232354932.png" alt="image-20231225232354932" style="zoom:50%;" />

| Port name | Direction | Type  | Description   |
| --------- | --------- | ----- | ------------- |
| clk       | input     |       | 时钟信号      |
| rst       | input     |       | 复位信号      |
| data      | input     | [5:0] | 输入的数据    |
| col0      | output    | [7:0] | 输出数据第1行 |
| col1      | output    | [7:0] | 输出数据第2行 |
| col2      | output    | [7:0] | 输出数据第3行 |
| col3      | output    | [7:0] | 输出数据第4行 |
| col4      | output    | [7:0] | 输出数据第5行 |
| col5      | output    | [7:0] | 输出数据第6行 |
| col6      | output    | [7:0] | 输出数据第7行 |

### 子模块：InController

可以根据用户的需求弹奏制定的音符，并包含音高变化。

<img src="Project.assets/image-20231225232623930.png" alt="image-20231225232623930" style="zoom:50%;" />

| Port name | Direction | Type  | Description    |
| --------- | --------- | ----- | -------------- |
| sel       | input     | [6:0] | 用户的当前输入 |
| octave    | input     | [1:0] | 音高设定输入   |
| _mode     | input     | [1:0] | 模式           |
| note      | output    | [4:0] | 输出音符的音高 |

### 子模块：AutoController

自动播放存储的曲子，并可以暂停、切歌等，可以播放4首不同的乐曲。

<img src="Project.assets/image-20231225232842787.png" alt="image-20231225232842787" style="zoom:50%;" />

| Port name | Direction | Type  | Description        |
| --------- | --------- | ----- | ------------------ |
| rset      | input     |       | 重置信号           |
| clk       | input     |       | 时钟信号           |
| num       | input     | [6:0] | 对应的歌曲ID       |
| _mode     | input     | [1:0] | 模式               |
| paused    | input     |       | 是否暂停中         |
| note      | output    | [4:0] | 对应播放音符的音高 |

实现子模块：

- `Library`，曲库模块。

### 子模块：Library

曲库模块，存储了4首预定义乐曲。

<img src="Project.assets/image-20231225233325284.png" alt="image-20231225233325284" style="zoom:50%;" />

| Port name | Direction | Type         | Description                                   |
| --------- | --------- | ------------ | --------------------------------------------- |
| num       | input     | [6:0]        | 对应的歌曲ID                                  |
| pcs       | output    | wire [700:0] | 当前对应歌曲的所有音符（上限长度：700位）     |
| len       | output    | wire [300:0] | 当前对应歌曲的所有音符长度（上限长度：300位） |
| is        | output    | wire [7:0]   | 当前对应歌曲的总音数                          |
| scale     | output    | wire [2:0]   | 歌曲对应的默认音高（低/中/高）                |

### 子模块：LearnController

学习模式，不断提示用户弹奏指定长度的下一个指定音符，并可以根据是否弹奏正确和相关时间间隔，给出分数、评级。这一模块中还实现了多用户。

<img src="Project.assets/image-20231225233712517.png" alt="image-20231225233712517" style="zoom:50%;" />

| Port name         | Direction | Type  | Description              |
| ----------------- | --------- | ----- | ------------------------ |
| rset              | input     |       | 重置信号                 |
| clk               | input     |       | 时钟信号                 |
| num               | input     | [6:0] | 当前乐曲ID               |
| _mode             | input     | [1:0] | 当前模式                 |
| sel               | input     | [6:0] | 当前用户输入音符         |
| user_id           | input     | [3:0] | 当前用户ID               |
| note              | output    | [4:0] | 输出音符音高             |
| score             | output    | [9:0] | 当前分数                 |
| play              | output    |       | 是否在播放               |
| update_grade_flag | output    |       | 更新评级，确保只更新一次 |
| grade             | output    | [1:0] | 当前用户当前曲目对应评级 |

## Bonus 实现说明

### 键位调整模式

在这一模式下（`mode==2'b00`)，先后播放七个音符，并记录所对应设置的拨码开关作为新的这种音符的对应拨码开关，记录在`parser_table[6:0]`中，具体的输入输出详见`sel_alter_manager`模块。

随后，在手动模式和学习模式中，将会将信号通过`parser_table`处理，并以`parsed_sel`的端口向外传输，实现键位的调整。

### 音频节奏的更多变化

在这一模块中，我们实现了更多的音频节奏变化，具体来讲，不同的音符长度包括二分音符、四分音符、八分音符和十六分音符，以及休止符，实现了更多的音乐节奏变化。在`AutoController`即自动模式下，`len`用于保存每一个音符的长度，它是一个上百位长的二进制数，每两位代表一个音符的长度，具体的长度对应关系如下：

| 长度 | 二进制 |
| ---- | ------ |
| 1/2  | 00     |
| 1/4  | 01     |
| 1/8  | 10     |
| 1/16 | 11     |

### 学习模式评分与时间相关

在这一模块中，我们实现了学习模式的评分与反应时间相关，具体来讲，用户的反应时间越长，分数越低，反之分数越高。对于每一个音符，其对应关系如下：

| 反应时间 | 分数 |
| -------- | ---- |
| <300ms       | +5  |
| <500ms       | +4  |
| <700ms       | +3  |
| $\ge$700ms      | +1  |

在`LearnController`即学习模式下，`score`用于保存当前的分数，`update_grade_flag`用于更新评级，`grade`用于保存当前的评级，`grade`与`score`的对应关系也与乐曲长度有关，具体计算公式如下：

$$
grade=\begin{cases}S&,score\geq 4\times len\\ A&,4\times len>score\geq 3\times len\\ B&,3\times len>score\geq 2\times len\\ C&,otherwise\end{cases}
$$

### VGA

在这一模块中，我们提供了VGA的输出，包括当前模式的静态信息，以及当前音符和当前歌曲的动态信息。在自动模式下，音符信息随着自动播放进程推进自动播放；在学习模式下，可以用于提示具体的按键，以及其合适的进入、离开时间。

在这里，每个字符位由一个`char_set`模块控制，并由`state_data_control`、`note_data_control`、`name_data_control`三个模块分别控制其输出指定的信息。最后，运行两个循环来维护`hs`和`vs`，即`horizontal_sync`与`vertical_sync`扫描信号，在有字符的部分维护`r`，`g`，`b`三个通道的输出达成显示字符的目的。

### 暂停和重启（自定义Bonus）

我们实现了自动模式下的暂停和重启功能，具体来讲，当用户按下`pause`对应的按钮时，自动模式下的播放会暂停，再次按下`pause`按钮时，自动模式下的播放会继续。在`AutoController`即自动模式下，`paused`用于保存当前的播放状态。在每个时钟上升沿，假如`paused`为`1`，则`note`输出为`0`，即不播放音符，假如`paused`为`0`，则`note`输出为当前音符的音高。

### 升降调（自定义Bonus）

为了使得音乐更加丰富，我们实现了升降调的功能，具体来讲，我们计算了三种调式下音符的对应频率，当用户按下`butscale`对应的按钮时，自动模式下的播放会转换调式，目前可用的调式有C大调、F大调与B大调。在`AutoController`即自动模式下，`scale`用于保存当前的升降调状态，而具体的升降调对应关系则存储在`Buzzer`中。

## 项目总结

### 遇到的一些问题与解决方案
 1. 在合作开发的过程中，我们发现reset的使用时常会发生混乱，为了解决这个问题，我们需要在开发使用之前就尽量统一reset的用法，不然会发生一些功能上的错误。
 2. 在使用状态机的过程中，我们发现时序逻辑中辨别同步复位和异步复位很重要，这会影响你的代码执行顺序和逻辑，不然会发生一些不可名状的错误。所以在编写代码前应该先描绘一下状态机、状态转移的过程，这样会更便于开发。
 3. 在后期检查时，我们经常会发现一些冗余的wire、reg接口，在调试过程中留下的痕迹。我们在后期检查时都修理了这些部分，发现项目在开发板上的运行准确度明显有所提高，所以代码也应该尽量的轻量化。


### 可能的远期优化
#### 1.目前代码还主要以实现功能为主，即使我们已经在很多部分进行了模块化的搭建，但依然存在可以优化的部分。
#### 2.我们可以继续完善功能，例如增加歌曲的录制与存储、完善VGA的显示内容等等。
#### 3.我们现在的曲库在学习模式中需要演奏的时间都过长，我们可以增添一些长度不高的歌曲来更方便学习模式的使用。
#### 4.可以添加更多的调式和曲库，甚至可以尝试模仿各种乐器的音色来实现真正的电子琴。

### 心得

> 音乐表达那些无法言说的事情，而且对于那些无法保持沉默的事情，音乐是最好的言辞。 ——王尔德

在这个Mini Piano项目的开发过程中，我们的项目仿佛是一曲悠扬的交响乐，用琴键奏响了我们对硬件语言的独特理解：每个模块都是一段数码的旋律，每一次讨论都是一次思维的碰撞。团队合作如同一场*Mini Piano Concerto*，每位成员都是独一无二的音符，是我们共同的努力奏响了数字逻辑的交响曲。正如费尔南多·佩索阿所说：“合作是一种艺术，就像音乐一样，需要和谐与默契。”

妮可的计系常常被诟病课业压力重：这是事实。然而，我们的团队却在这样的压力下，完成了这样一个项目，尽管不一定非常完美。我们都有着自己的课业压力，但是我非常感激每个成员都在这个项目中付出了自己的努力，同时也学到了很多只有“Get your hands dirty”才能学到的东西。

同时，我也非常感谢数字逻辑这门课。在这门课上，我学到了很多关于数字电路的知识，也学到了很多关于团队合作的经验。当然，这也离不开老师和助教的优秀以及辛勤付出，他们的教学让我们受益匪浅。

> See you next semester in Computer Organization!

## 对 Project 对想法和建议

如果我们出题，将会提供以下建议：

### 1. 游戏手柄

利用开发板实现一个全功能、高度可定制化的游戏手柄实现，并设计为可以用于操纵特定的一两款游戏，还可以具有多元的操控方案。

### 2. 智能家居终端

利用真实的传感器数据或者电脑模拟的数据，实现智能家居的自动控制，并可以手动增删新的家具，并管理各个家具的自动调整方式，如对热水器、空调自动设置温度，电动窗帘自动开合，智能门锁等进行模拟。

### 3. 真正的音乐播放器

利用纯粹的 Verilog，实现 WAV 文件的读取、解析和播放。实现以下功能：音乐解析播放，音乐 Metadata 解析，暂停/重播/切歌，文件管理。可能的Bonus：支持更多文件格式，支持流式读取来处理更大的文件。

> 灵感来源：C++ Project by Site Fan and Kangrui Chen.

### 4. 电子表

利用开发板实现电子表，并支持以下功能：显示时间，设置时区并切换多种世界时钟，计时器，秒表（支持专业体育用秒表的功能），以及闹钟。
