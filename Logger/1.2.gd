extends Node
const SRC_NAME = "Logger.gd"

#------------------------
#		说明
#
#	输出格式为:
#	时间|等级|脚本|文本
#
#	使用方法
#	Logger.output("脚本名称", "文字内容", log等级)
#
#	模板, 直接复制改内容
#	const SRC_NAME = ""
#	Logger.output(SRC_NAME, "", )
#
#	log等级列表:
#	0 == Debug
#	1 == Info
#	2 == Waring
#	3 == Error
#
#	Version: 1.2
#-------------------------
#	Config

#启用Logger
const LOGGER_ENABLE = true
#仅时间，不显示日期
const TIEM_ONLY = false
#使用UTC时间
const UTC = false

#日志输出文件
const OUTPUT_LOG = false
#PC日志输出文件
const OUTPUT_LOG_PC = true
#发布后输出日志文件
const OUTPUT_LOG_IN_RELEASE = true
#最多保留日志文件数量
const MAX_LOG_FILE = 5
#日志输出文件路径
const OUTPUT_PATH = ""

#就绪时打印 Logger Ready!
const READY_PRINT = true

#-------------------------
#	Body

func _ready():
	
	if OUTPUT_LOG == true:
		#Debug判断
		if OS.is_debug_build() == false && OUTPUT_LOG_IN_RELEASE == false:
			ProjectSettings.set_setting("debug/file_logging/enable_file_logging", false)
		else:
			ProjectSettings.set_setting("debug/file_logging/enable_file_logging", true)
	else:
		ProjectSettings.set_setting("debug/file_logging/enable_file_logging", false)
	
	if OUTPUT_LOG_PC == true:
		ProjectSettings.set_setting("debug/file_logging/enable_file_logging.pc", true)
	else:
		ProjectSettings.set_setting("debug/file_logging/enable_file_logging.pc", false)
	
	ProjectSettings.set_setting("debug/file_logging/max_log_files", MAX_LOG_FILE)
	
	if READY_PRINT == true:
		self.output(SRC_NAME, "Logger Ready!", 1)


var time
var levelText

func output(src: String, msg: String, level: int):
	#时间配置
	if TIEM_ONLY == true:
		time = Time.get_time_string_from_system(UTC)
	elif TIEM_ONLY == false:
		time = Time.get_datetime_string_from_system(UTC, true)
	
	#等级配置
	if level == 0:
		levelText = "DEBUG"
	elif level == 1:
		levelText = "INFO"
	elif level == 2:
		levelText = "WARNING"
	elif level == 3:
		levelText = "ERROR"
	
	else:
		output(SRC_NAME, "input error levelnum", 3)
	

	#最终打印
	#真不会用%s
	print(time + '|' + levelText + '|' + src + '|' + msg)
