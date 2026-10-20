extends Control

const LOCATIONS := ["Квартира", "Подъезд", "Двор Гниловска"]
var location: int = 0
var evidence: Dictionary = {}
var flags: Dictionary = {}
var node_id := "intro"
var heading: Label
var story: RichTextLabel
var choices: VBoxContainer
var status: Label

const DIALOGUES := {
 "intro": {"speaker":"ПЕЧЕНЬ", "text":"Я три дня подавала сигналы бедствия. Теперь ты проснулся и делаешь вид, что у тебя просто понедельник.", "options":[["Осмотреть квартиру","room"],["Посмотреть в зеркало","mirror"]]},
 "room":{"speaker":"ВАЛЕРИЙ","text":"Чужая квартира. Чужой ботинок. На столе бутылки и разбитый будильник.", "options":[["Открыть холодильник","fridge"],["Изучить часы","watch"],["Осмотреть телевизор","tv"],["Выйти в подъезд","nyura"]]},
 "mirror":{"speaker":"СТЫД","text":"Ну здравствуй, человек, которого до сих пор не объявили в розыск только из-за низкого качества фотографии.", "options":[["Вернуться","room"]]},
 "fridge":{"speaker":"ПОХМЕЛЬНЫЙ ПРОРОК","text":"Четыре пельменя. Фотография женщины. Записка: «Валера, если ты это читаешь — значит, председатель ещё жив. Исправь ситуацию».", "give":"Записка", "options":[["Взять записку","room"],["Вернуться","room"]]},
 "watch":{"speaker":"ОСТАТКИ ИНТЕЛЛИГЕНЦИИ","text":"Часы не твои. Стрелки остановились на 02:40. Вдруг этот час важнее всей остальной жизни?", "give":"Чужие часы", "options":[["Вернуться","room"]]},
 "tv":{"speaker":"ТЕЛЕВИЗОР «РУБИН»","text":"...Сегодня в Гниловске проходят похороны директора завода. Одновременно директор подписал постановление о приватизации столовой...", "give":"Новости о директоре", "options":[["Вернуться","room"]]},
 "nyura":{"speaker":"БАБА НЮРА","text":"Валерка! Ну и рожу тебе Господь сохранил. Вчера ты на похоронах был, а ночью председателя звал. Я в глазок видела!", "options":[["Кого хоронили?","funeral"],["Вы ничего не перепутали?","nyura_angry"],["Спуститься во двор","courtyard"]]},
 "funeral":{"speaker":"БАБА НЮРА","text":"Директора Сан Саныча. Только он на похоронах сам присутствовал. В тёмных очках. У нас в городе даже мёртвые без связей не проходят.", "give":"Показания Нюры", "options":[["Спуститься во двор","courtyard"],["Ещё вопросы","nyura"]]},
 "nyura_angry":{"speaker":"БАБА НЮРА","text":"Я сорок лет в этом подъезде живу! Я соседей по звуку шагов узнаю. А ты себя в зеркале — нет.", "options":[["Ладно. Во двор","courtyard"]]},
 "courtyard":{"speaker":"БЛАТНАЯ ИНТУИЦИЯ","text":"Двор пахнет мокрым асфальтом, сигаретами и приватизацией. Толик у машины. Зина у ларька. Профессор у ДК.", "options":[["Поговорить с Толиком","tolik"],["Поговорить с Зинаидой","zina"],["Поговорить с профессором","eduard"],["Посмотреть улики","journal"],["Вернуться в подъезд","nyura"]]},
 "tolik":{"speaker":"ТОЛИК «ДИПЛОМАТ»","text":"Валера, рад тебя видеть. У нас возникло дипломатическое недоразумение. Ты должен мне пять тысяч долларов.", "options":[["За что?","tolik_debt"],["У нас международные отношения?","tolik_joke"],["Пока, Толян","courtyard"]]},
 "tolik_debt":{"speaker":"ТОЛИК «ДИПЛОМАТ»","text":"Ты сам принёс бумаги с завода. Теперь бумаги исчезли, а у меня неприятные вопросы. Верни папку — и мы обсудим реструктуризацию долга.", "give":"След: заводская папка", "options":[["Что за папка?","tolik_folder"],["Отойти","courtyard"]]},
 "tolik_joke":{"speaker":"ТОЛИК «ДИПЛОМАТ»","text":"Разумеется. Я представляю министерство внутренних вопросов. Сейчас готовлю пакет санкций на твоё лицо.", "options":[["Ладно, про долг","tolik_debt"],["Отойти","courtyard"]]},
 "tolik_folder":{"speaker":"БЛАТНАЯ ИНТУИЦИЯ","text":"Он не про деньги говорит. Кто-то пытается заставить Валеру вспомнить бумаги, о которых удобнее молчать.", "options":[["Отойти","courtyard"]]},
 "zina":{"speaker":"ЗИНАИДА ПЕТРОВНА","text":"О! Наш покойник в гражданском. Помидоры будешь брать или опять историю государства пересказывать?", "options":[["Какого покойника?","zina_dead"],["Что слышно о заводе?","zina_factory"],["Отойти","courtyard"]]},
 "zina_dead":{"speaker":"ЗИНАИДА ПЕТРОВНА","text":"Того самого директора. Хоронили одного, а подпись от него сегодня пришла. У нас теперь всё с доставкой на дом.", "give":"Подпись после смерти", "options":[["Отойти","courtyard"]]},
 "zina_factory":{"speaker":"ЗИНАИДА ПЕТРОВНА","text":"Завод обанкротили, зато столовую хотят продать три раза. Рабочим зарплату тазиками выдали. Говорят, твоё имя в бумагах тоже имеется.", "give":"Слухи рынка", "options":[["Отойти","courtyard"]]},
 "eduard":{"speaker":"ЭДУАРД МАРКОВИЧ","text":"Валерий Аркадьевич, рыночная экономика — это когда человек продаёт собственную биографию и удивляется, что сдачу не дали.", "options":[["Вы что-то знаете о директоре?","eduard_fact"],["Это философия?","eduard_philosophy"],["Отойти","courtyard"]]},
 "eduard_fact":{"speaker":"ЭДУАРД МАРКОВИЧ","text":"Последняя подпись директора датирована утром после его похорон. Факт, который не помещается ни в диалектику, ни в уголовное дело.", "give":"Дата подписи", "options":[["Отойти","courtyard"]]},
 "eduard_philosophy":{"speaker":"ЭДУАРД МАРКОВИЧ","text":"Нет, Валерий. Философия была у меня на кафедре. А это теперь трудовая биография.", "options":[["Отойти","courtyard"]]},
 "journal":{"speaker":"ЖУРНАЛ РАССЛЕДОВАНИЯ","text":"Собрано улик: {evidence}. Главный вопрос: кого похоронили, если директор продолжает подписывать документы?", "options":[["Вернуться во двор","courtyard"]]}
}
func _ready() -> void:
 var bg := ColorRect.new()
 bg.color = Color("#1c2526")
 bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(bg)
 var root := VBoxContainer.new()
 root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 root.add_theme_constant_override("separation", 12)
 root.offset_left = 38
 root.offset_top = 28
 root.offset_right = -38
 root.offset_bottom = -28
 add_child(root)
 heading = Label.new()
 heading.add_theme_font_size_override("font_size", 28)
 root.add_child(heading)
 status = Label.new()
 root.add_child(status)
 story = RichTextLabel.new()
 story.bbcode_enabled = true
 story.size_flags_vertical = Control.SIZE_EXPAND_FILL
 story.add_theme_font_size_override("normal_font_size", 21)
 root.add_child(story)
 choices = VBoxContainer.new()
 choices.add_theme_constant_override("separation", 7)
 root.add_child(choices)
 var footer := HBoxContainer.new()
 root.add_child(footer)
 for name in ["Сохранить","Загрузить","В начало"]:
  var b := Button.new()
  b.text = name
  footer.add_child(b)
  if name == "Сохранить": b.pressed.connect(save_game)
  elif name == "Загрузить": b.pressed.connect(load_game)
  else: b.pressed.connect(func(): show_node("intro"))
 show_node("intro")
func show_node(id: String) -> void:
 if not DIALOGUES.has(id): return
 node_id = id
 var data: Dictionary = DIALOGUES[id]
 if data.has("give"):
  evidence[str(data["give"])] = true
 if id in ["nyura","funeral"]: location = 1
 if id in ["courtyard","tolik","tolik_debt","tolik_joke","tolik_folder","zina","zina_dead","zina_factory","eduard","eduard_fact","eduard_philosophy","journal"]: location = 2
 heading.text = "ПОСЛЕДНИЙ РАССОЛ  |  " + LOCATIONS[location]
 status.text = "Гниловск, 1996     •     Улик найдено: " + str(evidence.size())
 var message: String = str(data["text"]).replace("{evidence}",", ".join(evidence.keys()))
 story.text = "[color=#d5bd85][b]" + str(data["speaker"]) + "[/b][/color]\n\n" + message
 for child in choices.get_children(): child.queue_free()
 for option in data["options"]:
  var b := Button.new()
  b.text = str(option[0])
  b.custom_minimum_size = Vector2(0,40)
  choices.add_child(b)
  var target: String = str(option[1])
  b.pressed.connect(func(): show_node(target))
func save_game() -> void:
 var f := FileAccess.open("user://last_pickle_save.json", FileAccess.WRITE)
 if f: f.store_string(JSON.stringify({"node":node_id,"evidence":evidence}))
func load_game() -> void:
 if not FileAccess.file_exists("user://last_pickle_save.json"): return
 var f := FileAccess.open("user://last_pickle_save.json",FileAccess.READ)
 if not f: return
 var parsed: Variant = JSON.parse_string(f.get_as_text())
 if typeof(parsed) != TYPE_DICTIONARY: return
 evidence = parsed.get("evidence",{})
 show_node(str(parsed.get("node","intro")))
