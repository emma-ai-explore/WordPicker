#!/usr/bin/env python3
"""
创建测试词典数据库
"""

import sqlite3
import os

def create_test_dict():
    db_path = "WordPicker/Resources/dict.db"

    # 确保目录存在
    os.makedirs(os.path.dirname(db_path), exist_ok=True)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS words (
            word TEXT PRIMARY KEY,
            phonetic TEXT,
            translation TEXT
        )
    """)

    # 常用英文单词测试数据
    test_words = [
        ("hello", "/həˈləʊ/", "int. 你好；喂\nn. 问候"),
        ("world", "/wɜːld/", "n. 世界；地球；领域"),
        ("apple", "/ˈæpl/", "n. 苹果；苹果树"),
        ("book", "/bʊk/", "n. 书；书籍\nvt. 预订"),
        ("computer", "/kəmˈpjuːtə/", "n. 计算机；电脑"),
        ("development", "/dɪˈveləpmənt/", "n. 发展；开发；发育"),
        ("software", "/ˈsɒftweə/", "n. 软件"),
        ("language", "/ˈlæŋɡwɪdʒ/", "n. 语言；语言文字"),
        ("translation", "/trænzˈleɪʃn/", "n. 翻译；译文"),
        ("dictionary", "/ˈdɪkʃənri/", "n. 字典；词典"),
        ("word", "/wɜːd/", "n. 单词；词；话语\nvt. 用词语表达"),
        ("text", "/tekst/", "n. 文本；课文\nadj. 文本的"),
        ("selection", "/sɪˈlekʃn/", "n. 选择；挑选；选集"),
        ("monitor", "/ˈmɒnɪtə/", "n. 显示器；监视器\nvt. 监控"),
        ("service", "/ˈsɜːvɪs/", "n. 服务；服役\nvt. 维修；保养"),
        ("window", "/ˈwɪndəʊ/", "n. 窗户；窗口\nvt. 给...开窗"),
        ("application", "/ˌæplɪˈkeɪʃn/", "n. 应用；申请；应用程序"),
        ("system", "/ˈsɪstəm/", "n. 系统；制度；体系"),
        ("function", "/ˈfʌŋkʃn/", "n. 功能；函数\nvi. 运行"),
        ("method", "/ˈmeθəd/", "n. 方法；条理"),
        ("class", "/klɑːs/", "n. 班级；阶级；种类\nvt. 分类"),
        ("object", "/ˈɒbdʒɪkt/", "n. 物体；对象；目标\nvi. 反对"),
        ("string", "/strɪŋ/", "n. 字符串；线；弦\nvt. 串起"),
        ("integer", "/ˈɪntɪdʒə/", "n. 整数"),
        ("value", "/ˈvæljuː/", "n. 值；价值\nvt. 评价"),
        ("variable", "/ˈveəriəbl/", "n. 变量\nadj. 可变的"),
        ("constant", "/ˈkɒnstənt/", "n. 常量\nadj. 恒定的"),
        ("import", "/ɪmˈpɔːt/", "vt. 导入；进口\nn. 进口商品"),
        ("export", "/ɪkˈspɔːt/", "vt. 导出；出口\nn. 出口商品"),
        ("return", "/rɪˈtɜːn/", "vi. 返回\nn. 返回；回报"),
        ("print", "/prɪnt/", "vt. 打印；印刷\nn. 印刷品"),
        ("read", "/riːd/", "vt. 阅读；读取\nvi. 读"),
        ("write", "/raɪt/", "vt. 写；写入\nvi. 写"),
        ("delete", "/dɪˈliːt/", "vt. 删除"),
        ("create", "/kriˈeɪt/", "vt. 创建；创造"),
        ("update", "/ʌpˈdeɪt/", "vt. 更新\nn. 更新"),
        ("query", "/ˈkwɪəri/", "n. 查询\nvt. 询问"),
        ("database", "/ˈdeɪtəbeɪs/", "n. 数据库"),
        ("table", "/ˈteɪbl/", "n. 表格；桌子\nvt. 制表"),
        ("column", "/ˈkɒləm/", "n. 列；专栏；圆柱"),
        ("row", "/rəʊ/", "n. 行；排\nvt. 划船"),
        ("index", "/ˈɪndeks/", "n. 索引；指标\nvt. 编入索引"),
        ("type", "/taɪp/", "n. 类型；种类\nvt. 打字"),
        ("model", "/ˈmɒdl/", "n. 模型；模范\nvt. 模仿"),
        ("view", "/vjuː/", "n. 视图；观点\nvt. 观察"),
        ("controller", "/kənˈtrəʊlə/", "n. 控制器；管理者"),
        ("button", "/ˈbʌtn/", "n. 按钮；纽扣\nvt. 扣住"),
        ("menu", "/ˈmenjuː/", "n. 菜单"),
        ("icon", "/ˈaɪkɒn/", "n. 图标；偶像"),
        ("image", "/ˈɪmɪdʒ/", "n. 图像；形象\nvt. 想象"),
        ("file", "/faɪl/", "n. 文件；档案\nvt. 归档"),
        ("folder", "/ˈfəʊldə/", "n. 文件夹"),
        ("path", "/pɑːθ/", "n. 路径；道路"),
        ("name", "/neɪm/", "n. 名称；名字\nvt. 命名"),
        ("title", "/ˈtaɪtl/", "n. 标题；头衔\nvt. 加标题"),
        ("description", "/dɪˈskrɪpʃn/", "n. 描述；说明书"),
        ("comment", "/ˈkɒment/", "n. 注释；评论\nvt. 评论"),
        ("error", "/ˈerə/", "n. 错误；误差"),
        ("warning", "/ˈwɔːnɪŋ/", "n. 警告\nadj. 警告的"),
        ("success", "/səkˈses/", "n. 成功"),
        ("fail", "/feɪl/", "vi. 失败\nvt. 使失望"),
        ("test", "/test/", "n. 测试；试验\nvt. 测试"),
        ("debug", "/diːˈbʌɡ/", "vt. 调试\nn. 调试"),
        ("build", "/bɪld/", "vt. 构建；建造\nn. 构建"),
        ("run", "/rʌn/", "vi. 运行；跑\nvt. 运行"),
        ("stop", "/stɒp/", "vi. 停止\nvt. 停止"),
        ("start", "/stɑːt/", "vt. 开始\nn. 开始"),
        ("end", "/end/", "n. 结束；末端\nvt. 结束"),
        ("begin", "/bɪˈɡɪn/", "vi. 开始\nvt. 开始"),
        ("finish", "/ˈfɪnɪʃ/", "vt. 完成\nvi. 结束"),
        ("complete", "/kəmˈpliːt/", "vt. 完成\nadj. 完整的"),
        ("empty", "/ˈempti/", "adj. 空的\nvt. 倒空"),
        ("full", "/fʊl/", "adj. 满的；完整的"),
        ("true", "/truː/", "adj. 真实的；正确的\nadv. 真实地"),
        ("false", "/fɔːls/", "adj. 错误的；假的"),
        ("null", "/nʌl/", "adj. 空的\nn. 零"),
        ("default", "/dɪˈfɔːlt/", "n. 默认\nadj. 默认的"),
    ]

    count = 0
    for word, phonetic, translation in test_words:
        try:
            cursor.execute(
                "INSERT OR IGNORE INTO words (word, phonetic, translation) VALUES (?, ?, ?)",
                (word.lower(), phonetic, translation)
            )
            count += 1
        except:
            pass

    conn.commit()
    conn.close()
    print(f"Created test dictionary with {count} words at {db_path}")

if __name__ == "__main__":
    create_test_dict()
