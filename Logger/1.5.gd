extends Node
const SCR_NAME: String = "Logger.gd"

#------------------------
#		说明
#
#	第一次使用请在 项目>项目设置>自动加载 添加这个脚本
#
#	输出格式为:
#	时间|等级|脚本|文本
#
#	使用方法
#	Logger.output("脚本名称", "文字内容", log等级)
#
#	模板, 直接复制改内容
#	const SCR_NAME: String = ""
#	Logger.output(SCR_NAME, "", )
#
#	log等级列表:
#	0 == Debug
#	1 == Info
#	2 == Waring
#	3 == Error
#
#	Version: 1.5
#-------------------------
#	配置 Config

#启用Logger
const LOGGER_ENABLE: bool = true
#仅时间，不显示日期
const TIEM_ONLY: bool = false
#使用UTC时间
const TIME_UTC: bool = false

#就绪时打印 Logger Ready!
const READY_PRINT: bool = true

#等级启用
const ENABLE_DEBUG: bool = true
const ENABLE_INFO: bool = true
const ENABLE_WARNING: bool = true
const ENABLE_ERROR: bool = true

#日志输出文件
const OUTPUT_LOG: bool = false
#PC日志输出文件
const OUTPUT_LOG_PC: bool = true
#发布后输出日志文件
const OUTPUT_LOG_IN_RELEASE: bool = true
#最多保留日志文件数量
const MAX_LOG_FILE: int = 5
#日志输出文件路径
const OUTPUT_LOG_PATH: String = "user://logs/godot.log"

#-------------------------
#	主体 Body

func _ready() -> void:
	#十分抽象，但是能用
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
	ProjectSettings.set_setting("debug/file_logging/log_path", OUTPUT_LOG_PATH)
	
	if READY_PRINT == true:
		self.output(SCR_NAME, "Logger Ready!", 1)
	
	if LOGGER_ENABLE == false:
		print("Logger is disable!")

#输出log
var time: String
func output(scr: String, msg: String, level: int) -> void:
	#时间配置
	if TIEM_ONLY == true:
		time = Time.get_time_string_from_system(TIME_UTC)
	elif TIEM_ONLY == false:
		time = Time.get_datetime_string_from_system(TIME_UTC, true)
	
	#等级配置
	var levelText: String
	if level == 0:
		levelText = "DEBUG"
	elif level == 1:
		levelText = "INFO"
	elif level == 2:
		levelText = "WARNING"
	elif level == 3:
		levelText = "ERROR"
	
	else:
		output(SCR_NAME, "input error levelnum", 3)
	
	
	if OUTPUT_LOG == true:
		ProjectSettings.set_setting("debug/file_logging/enable_file_logging", true)
	else:
		ProjectSettings.set_setting("debug/file_logging/enable_file_logging", false)
	
	if LOGGER_ENABLE == true:
		#最终打印
		#真不会用%s
		if level == 0 && ENABLE_DEBUG == true:
			print(time + '|' + levelText + '|' + scr + '|' + msg)
		if level == 1 && ENABLE_INFO == true:
			print(time + '|' + levelText + '|' + scr + '|' + msg)
		if level == 2 && ENABLE_WARNING == true:
			print(time + '|' + levelText + '|' + scr + '|' + msg)
		if level == 3 && ENABLE_ERROR == true:
			print(time + '|' + levelText + '|' + scr + '|' + msg)
