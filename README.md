# ESG-Bertopic

本项目基于 **BERTopic** 做了面向 ESG/年报文本的流程化处理与微调，文档中记录：微调后的 BERTopic 相较原生模型**准确率提升 53%**

---

## 项目结构

仓库根目录如下：

```text
.
├─ ckpt/                 # 模型/中间产物
├─ SFT/                  # 微调与效果验证脚本
├─ tools/                # 数据抓取与格式转换工具脚本
├─ Bertopic_end4.py      # 生成 BERTopic 聚类结果的入口脚本
└─ README.md
```

---

## 环境要求（建议）

- Python 3.9
- `requirements.txt`：  
  ```bash
  pip install -r requirements.txt
  ```
---

## 使用流程

### 1）数据预处理（tools）

#### 1.1 自动化下载年报、ESG 报告
运行 `tools/ESGget.py` 自动化下载企业年报、ESG 报告。

```bash
python tools/ESGget.py
```

#### 1.2 PDF 转 Excel
运行 `tools/LLMPdfToExcel.py`，使用大模型将自动下载的 PDF 转为 Excel。

```bash
python tools/LLMPdfToExcel.py
```

#### 1.3 TXT 转 Excel
运行 `tools/LLMTxtToexcel.py`，将某网站已有的 txt 文件转为 Excel。

```bash
python tools/LLMTxtToexcel.py
```
---

### 2）大模型微调（SFT）

#### 2.1 微调
运行 `SFT/Bertopic_person.py` 得到微调后的模型（或权重）。

```bash
python SFT/Bertopic_person.py
```

#### 2.2 验证微调效果
运行 `SFT/Bertopic_ACC.py` 验证微调效果。

```bash
python SFT/Bertopic_ACC.py
```

---

### 3）生成 BERTopic 聚类结果

运行根目录下的 `Bertopic_end4.py` 输出 BERTopic 聚类结果。

```bash
python Bertopic_end4.py
```

---

#### 双重机器学习验证
运行 `DDML` 得到双重机器学习验证结果。

```bash
python DDML.py
```
