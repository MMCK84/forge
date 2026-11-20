# -*- coding: utf-8 -*-
S = {}
def t(k, de, en): S[k] = (de, en)

t("GAME_TITLE", "Forge Workshop", "Forge Workshop")
t("GAME_SUBTITLE", "Eine Schmiede im Großbritannien des 18. und 19. Jahrhunderts", "A smithy in 18th- and 19th-century Britain")
t("LANG_DE", "Deutsch", "Deutsch")
t("LANG_EN", "English", "English")
# Menü
t("UI_CONTINUE_GAME", "Fortsetzen", "Continue")
t("UI_NEW_GAME", "Neues Spiel", "New game")
t("UI_NEW_GAME_WARNING", "Es gibt bereits einen Spielstand. Ein neues Spiel überschreibt ihn (der alte bleibt als Sicherung erhalten, bis zum nächsten Speichern). Fortfahren?", "A saved game already exists. A new game will overwrite it (the old one is kept as a backup until the next save). Continue?")
t("UI_SETTINGS", "Einstellungen", "Settings")
t("UI_CREDITS", "Mitwirkende", "Credits")
t("UI_QUIT", "Beenden", "Quit")
t("UI_SAVE_NEWER", "Der Spielstand stammt aus einer neueren Spielversion und kann nicht geladen werden. Die Datei bleibt unverändert.", "The saved game comes from a newer version of the game and cannot be loaded. The file is left unchanged.")
t("UI_SAVE_CORRUPT", "Der Spielstand ist beschädigt und konnte nicht geladen werden. Bitte beginnt ein neues Spiel.", "The saved game is damaged and could not be loaded. Please start a new game.")
t("UI_SAVE_RESTORED", "Der letzte Spielstand war beschädigt – die Sicherung wurde geladen.", "The latest save was damaged – the backup was loaded.")
t("UI_IMPORT_FAILED", "Import fehlgeschlagen: Die Datei ist kein gültiger Spielstand.", "Import failed: the file is not a valid saved game.")
t("CREDITS_TEXT", "Forge Workshop (Arbeitstitel)\n\nSpielidee und Lastenheft: der Auftraggeber\nUmsetzung: Godot 4 (GDScript)\n\nGrafik, Klänge und Musik sind vorläufige Platzhalter, die zur Laufzeit erzeugt werden.\n\nHistorische Eckdaten: Darby (Koks, 1709), Huntsman (Tiegelstahl, 1740er), Hargreaves (Spinning Jenny, um 1764), Watt (Patent 1769), Boulton & Watt (ab 1775), Eisenbrücke bei Coalbrookdale (1779), Wedgwoods Pyrometer (1782), Cort (Puddelverfahren, 1784).",
  "Forge Workshop (working title)\n\nGame idea and specification: the client\nImplementation: Godot 4 (GDScript)\n\nGraphics, sounds and music are provisional placeholders generated at runtime.\n\nHistorical landmarks: Darby (coke, 1709), Huntsman (crucible steel, 1740s), Hargreaves (spinning jenny, c. 1764), Watt (patent 1769), Boulton & Watt (from 1775), the Iron Bridge at Coalbrookdale (1779), Wedgwood's pyrometer (1782), Cort (puddling, 1784).")
# Allgemein
t("UI_OK", "OK", "OK")
t("UI_CANCEL", "Abbrechen", "Cancel")
t("UI_CLOSE", "Schließen", "Close")
t("UI_CONTINUE", "Weiter", "Continue")
t("UI_LATER", "Später", "Later")
t("UI_UNDERSTOOD", "Verstanden", "Understood")
t("UI_MENU", "Menü [Esc]", "Menu [Esc]")
t("UI_PAUSE", "Pause", "Paused")
t("UI_RESUME", "Fortsetzen", "Resume")
t("UI_SAVE_AND_QUIT", "Speichern & zum Hauptmenü", "Save & main menu")
t("UI_WELCOME_BACK", "Willkommen zurück!", "Welcome back!")
t("UI_OFFLINE_EARNINGS", "Während Eurer Abwesenheit ({t}) hat der Geselle {m} verdient.", "While you were away ({t}), your journeyman earned {m}.")
# HUD
t("UI_JOB_BOOK", "Auftragsbuch", "Order book")
t("UI_JOB_BOOK_SHORT", "Aufträge", "Orders")
t("UI_SHOP", "Laden", "Shop")
t("UI_STAFF", "Personal", "Staff")
t("UI_STATS", "Statistik", "Statistics")
t("UI_NEXT_EPOCH", "Neuer Standort!", "New premises!")
t("UI_NO_JOB", "Kein Auftrag – öffnet das Auftragsbuch [J].", "No order – open the order book [J].")
t("UI_HOURGLASS", "Sanduhr:", "Hourglass:")
t("UI_LATE", "verspätet", "late")
t("UI_RAW_STACK", "Rohlinge", "Blanks")
t("UI_TROUGH", "Löschtrog [Q]", "Quench trough [Q]")
t("UI_BTN_LOAD", "Rohling einlegen [R]", "Load blank [R]")
t("UI_BTN_MOVE", "Umlegen [E]", "Move piece [E]")
t("UI_BTN_HAMMER", "HAMMERN – Klick / Leertaste", "HAMMER – click / space")
t("UI_BTN_QUENCH", "Abschrecken [Q]", "Quench [Q]")
t("UI_PIECE_INFO", "Stück {i}/{n} · {p} %", "Piece {i}/{n} · {p} %")
t("UI_JOB_INFO", "Auftrag {p} % fertig", "Order {p} % complete")
t("UI_WELD_INFO", "Feuerschweißen {h}/{n}", "Forge weld {h}/{n}")
t("UI_QUENCH_INFO", "bereit zum Abschrecken", "ready to quench")
t("UI_DAMAGE_INFO", "Gefügeschaden {d} %", "Structural damage {d} %")
# Glutfarben
t("GLOW_NONE", "keine Glut", "no glow")
t("GLOW_FAINT_RED", "kaum sichtbares Dunkelrot", "faint dark red")
t("GLOW_DARK_RED", "Dunkelrot", "dark red")
t("GLOW_CHERRY", "Kirschrot", "cherry red")
t("GLOW_LIGHT_CHERRY", "Hellkirschrot", "light cherry red")
t("GLOW_RED_ORANGE", "Rotorange", "red-orange")
t("GLOW_ORANGE", "Orange", "orange")
t("GLOW_YELLOW_ORANGE", "Gelborange", "yellow-orange")
t("GLOW_YELLOW", "Gelb", "yellow")
t("GLOW_WHITE", "Weißglut – Vorsicht!", "white heat – careful!")
t("BADGE_WELD", "Schweißen!", "Weld!")
t("BADGE_QUENCH", "Abschrecken!", "Quench!")
# Effekte
t("FX_TOO_COLD", "Zu kalt!", "Too cold!")
t("FX_WELD_PHASE", "Schweißhitze! 1200–1300 °C", "Welding heat! 1200–1300 °C")
t("FX_WELD_DONE", "Geschweißt!", "Welded!")
t("FX_READY_TO_QUENCH", "Bei ca. 800 °C abschrecken!", "Quench at about 800 °C!")
t("FX_QUENCH_GOOD", "Richtig gehärtet", "Properly hardened")
t("FX_QUENCH_UNEVEN", "Ungleichmäßig", "Uneven")
t("FX_QUENCH_SOFT", "Zu weich", "Too soft")
t("FX_QUENCH_CRACK", "Härteriss", "Quench crack")
t("FX_BURNED", "Verbrannt! Ausschuss", "Burnt! Scrapped")
t("FX_CRACKED", "Gerissen! Ausschuss", "Cracked! Scrapped")
t("FX_PIECE_DONE", "Stück fertig", "Piece finished")
t("MSG_RUIN_COST", "Neuer Rohling: -{cost}", "New blank: -{cost}")
# Auftragsbuch
t("UI_ACTIVE_JOB", "Aktiver Auftrag", "Active order")
t("UI_ABORT_JOB", "Auftrag abbrechen", "Abandon order")
t("UI_ABORT_CONFIRM", "Wirklich abbrechen? Bereits verbrauchte Rohlinge werden nicht erstattet.", "Really abandon? Blanks already used are not refunded.")
t("UI_ACCEPT", "Annehmen", "Accept")
t("UI_REROLL", "Neue Angebote", "New offers")
t("UI_REROLL_WAIT", "Neue Angebote in {s} s", "New offers in {s} s")
t("UI_EPOCH_PROGRESS", "Aufträge in dieser Epoche: {n} / {total}", "Orders this era: {n} / {total}")
t("UI_FREE_PLAY_NOTE", "Freies Spiel: Die Aufträge gehen endlos weiter.", "Free play: orders continue endlessly.")
t("UI_QUANTITY", "Menge ×{n}", "Quantity ×{n}")
t("UI_OFFER_DETAILS", "{fp} Form-Punkte · Lohn {wage} (2 Sterne) · geschätzt {time}", "{fp} form points · pay {wage} (2 stars) · est. {time}")
t("UI_TIME_LIMIT", "Zeitlimit {time}", "time limit {time}")
t("TYPE_STANDARD", "Standard", "Standard")
t("TYPE_PRECISION", "Präzision (850–1000 °C)", "Precision (850–1000 °C)")
t("TYPE_RUSH", "Eilauftrag", "Rush order")
t("TYPE_MILESTONE", "Meilenstein", "Milestone")
t("CAT_WELD", "Feuerschweißen", "Forge welding")
t("CAT_HARDEN", "Härten", "Hardening")
t("CAT_BIG", "Großschmiedestück", "Heavy forging")
t("REQ_WELD_FORGE", "Benötigt eine Esse mit mindestens 1250 °C (Ziegel-Esse).", "Requires a forge reaching at least 1250 °C (brick forge).")
t("REQ_PRECISION_FORGE", "Benötigt eine Esse mit mindestens 1000 °C.", "Requires a forge reaching at least 1000 °C.")
t("REQ_TROUGH", "Benötigt einen Löschtrog (ab Epoche 4).", "Requires a quench trough (from era 4).")
t("ERR_JOB_ACTIVE", "Es läuft bereits ein Auftrag.", "An order is already in progress.")
t("ERR_INVALID", "Ungültiges Angebot.", "Invalid offer.")
t("JOB_TITLE", "{quality} {item} für {customer}", "{quality} {item} for {customer}")
t("JOB_TITLE_QTY", "{quality} {item} (×{qty}) für {customer}", "{quality} {item} (×{qty}) for {customer}")
for q, de, en in (("SIMPLE", ("Einfacher", "Einfache", "Einfaches", "Einfache"), "Simple"),
                  ("SOLID", ("Solider", "Solide", "Solides", "Solide"), "Solid"),
                  ("FINE", ("Feiner", "Feine", "Feines", "Feine"), "Fine"),
                  ("MASTERLY", ("Meisterlicher", "Meisterliche", "Meisterliches", "Meisterliche"), "Masterly")):
    for g, d in zip(("M", "F", "N", "PL"), de):
        t(f"QUALITY_{q}_{g}", d, en)
    t(f"QUALITY_{q}_-", de[0], en)
# Laden
t("UI_PURSE", "Münzbeutel", "Purse")
t("UI_SECTION_HAMMERS", "Hämmer", "Hammers")
t("UI_SECTION_UPGRADE", "Hammer verbessern", "Improve hammer")
t("UI_SECTION_FORGES", "Essen", "Forges")
t("UI_SECTION_MACHINES", "Maschinen", "Machines")
t("UI_HAMMER_INFO", "Schlagkraft {p}", "Striking power {p}")
t("UI_UPGRADE", "Schärfen, Nachhärten, besserer Stiel", "Dressing, re-hardening, better haft")
t("UI_UPGRADE_INFO", "{name}: Stufe {lvl}/{max} · Schlagkraft {p} (+10 % je Stufe)", "{name}: level {lvl}/{max} · striking power {p} (+10 % per level)")
t("UI_FORGE_INFO", "{k} °C/s · bis {t} °C · {s} Plätze", "{k} °C/s · up to {t} °C · {s} places")
t("UI_FORGE_BURN_NOTE", "Achtung: Ab der Esse mit Doppelblasebalg liegt die Höchsttemperatur über der Verbrennungsgrenze (1300 °C). Bleibt ein Werkstück zu lange im Feuer, verbrennt es.", "Careful: from the double-bellows forge upwards, the maximum temperature lies above the burning point (1300 °C). Leave a piece in the fire too long and it burns.")
t("UI_MACHINE_INFO", "Schlagkraft {p} · {h} Schläge/s", "Striking power {p} · {h} blows/s")
t("UI_MACHINE_COST", "Betriebskosten {c} je Minute", "running cost {c} per minute")
t("UI_MACHINE_WATER", "Leistung schwankt mit dem Wasserstand (60–100 %)", "output varies with the water level (60–100 %)")
t("UI_MACHINE_NOTE", "Maschinen schlagen automatisch zusätzlich zu Euren Schlägen, solange ein Werkstück (ab 400 °C) auf dem Amboss liegt. Es ist immer nur eine Maschine aktiv.", "Machines strike automatically in addition to your blows while a piece (400 °C or hotter) lies on the anvil. Only one machine is active at a time.")
t("UI_BUY", "Kaufen", "Buy")
t("UI_EQUIP", "Benutzen", "Use")
t("UI_EQUIPPED", "In Gebrauch", "In use")
t("UI_ACTIVATE", "Aktivieren", "Activate")
t("UI_ACTIVE", "Aktiv", "Active")
t("UI_MAXED", "Höchststufe", "Maximum")
t("UI_FROM_EPOCH", "ab Epoche {e}", "from era {e}")
t("HAMMER_HAND", "Handhammer", "Hand hammer")
t("HAMMER_CROSS_PEEN", "Kreuzschlaghammer", "Cross-peen hammer")
t("HAMMER_STEEL_FACED", "Hammer mit verstählter Bahn", "Steel-faced hammer")
t("HAMMER_CRUCIBLE", "Gussstahl-Hammer (Tiegelstahl)", "Crucible-steel hammer")
t("FORGE_CLAY", "Lehm-Esse mit Handblasebalg", "Clay forge with hand bellows")
t("FORGE_BRICK", "Ziegel-Esse", "Brick forge")
t("FORGE_DOUBLE_BELLOWS", "Esse mit Doppelblasebalg", "Forge with double bellows")
t("FORGE_COKE", "Koks-Esse mit Zylindergebläse", "Coke forge with blowing cylinders")
t("MACHINE_WATER_HELVE", "Wasser-Schwanzhammer", "Water-powered helve hammer")
t("MACHINE_STEAM_HELVE", "Dampf-Schwanzhammer", "Steam-powered helve hammer")
# Personal
t("STAFF_APPRENTICE", "Lehrling", "Apprentice")
t("STAFF_APPRENTICE_DESC", "Legt Werkstücke automatisch um: vom Amboss in die Esse, wenn sie abkühlen; zurück auf den Amboss, wenn sie heiß genug sind. Legt auch Rohlinge ein. Schwellen einstellbar.", "Moves pieces automatically: from the anvil into the fire when they cool, back onto the anvil when hot enough. Also loads blanks. Thresholds adjustable.")
t("STAFF_STRIKER", "Zuschläger", "Striker")
t("STAFF_STRIKER_DESC", "Schlägt mit dem Vorschlaghammer mit: Schlagkraft 20, ein Schlag alle 2 Sekunden.", "Strikes along with the sledgehammer: striking power 20, one blow every 2 seconds.")
t("STAFF_JOURNEYMAN", "Geselle", "Journeyman")
t("STAFF_JOURNEYMAN_DESC", "Bearbeitet im Hintergrund eigene Standardaufträge mit 25 % der Referenzleistung – auch während Ihr nicht spielt (bis zu 8 Stunden).", "Works his own standard orders in the background at 25 % of the reference output – even while you are not playing (up to 8 hours).")
t("UI_WAGE_SHARE_JOB", "Lohn: {p} % des Auftragslohns", "Wage: {p} % of the order pay")
t("UI_WAGE_SHARE_OWN", "Lohn: {p} % seiner Einnahmen", "Wage: {p} % of his earnings")
t("UI_HIRE", "Einstellen", "Hire")
t("UI_HIRED", "Eingestellt", "Hired")
t("UI_APPRENTICE_THRESHOLDS", "Schwellen des Lehrlings", "Apprentice thresholds")
t("UI_TO_FORGE_BELOW", "In die Esse unter", "Into the fire below")
t("UI_TO_ANVIL_AT", "Auf den Amboss ab", "Onto the anvil from")
t("UI_JOURNEYMAN_RATE", "Der Geselle verdient derzeit etwa {m} je Minute (nach seinem Lohn).", "Your journeyman currently earns about {m} per minute (after his wage).")
t("UI_STAFF_NOTE", "Lehrling und Zuschläger arbeiten nur, solange das Spiel läuft. Ihre Löhne werden bei Auftragsabschluss abgezogen.", "Apprentice and striker only work while the game is running. Their wages are deducted when an order is completed.")
# Einstellungen
t("UI_SFX_VOLUME", "Effekte", "Effects")
t("UI_MUSIC_VOLUME", "Musik", "Music")
t("UI_LANGUAGE", "Sprache", "Language")
t("UI_SHOW_CELSIUS", "Temperatur in °C anzeigen", "Show temperature in °C")
t("UI_HOLD_TO_HAMMER", "Halten-Modus (Gedrückthalten = 4 Schläge/s)", "Hold mode (hold = 4 blows/s)")
t("UI_SCREEN_SHAKE", "Bildschirmwackeln", "Screen shake")
t("UI_FLASH_EFFECTS", "Funken- und Blitzeffekte", "Spark and flash effects")
t("UI_FULLSCREEN", "Vollbild", "Fullscreen")
t("UI_TUTORIAL", "Tutorial und Hinweise", "Tutorial and hints")
t("UI_EXPORT_SAVE", "Spielstand exportieren", "Export saved game")
t("UI_IMPORT_SAVE", "Spielstand importieren", "Import saved game")
t("UI_EXPORT_NOTE", "Browserdaten können gelöscht werden – sichert Euren Spielstand regelmäßig als Datei.", "Browser data can be cleared – back up your saved game as a file regularly.")
# Statistik
t("STAT_PLAYTIME", "Spielzeit", "Play time")
t("STAT_EPOCH", "Epoche", "Era")
t("STAT_JOBS", "Abgeschlossene Aufträge", "Orders completed")
t("STAT_MILESTONES", "Meilensteine", "Milestones")
t("STAT_STARS", "Sterne", "Stars")
t("STAT_THREE_STARS", "Aufträge mit 3 Sternen", "Three-star orders")
t("STAT_REPUTATION", "Ruf", "Reputation")
t("STAT_EARNED", "Insgesamt verdient", "Total earned")
t("STAT_BEST", "Bester Auftrag", "Best order")
t("STAT_JOURNEYMAN", "Verdienst des Gesellen", "Journeyman's earnings")
t("STAT_RUINED", "Ausschuss", "Scrapped pieces")
t("STAT_HITS", "Hammerschläge", "Hammer blows")
t("REP_1", "Dorfschmied", "Village smith")
t("REP_2", "Geachteter Schmied", "Respected smith")
t("REP_3", "Angesehener Meister", "Esteemed master")
t("REP_4", "Berühmter Meisterschmied", "Renowned master smith")
t("REP_5", "Legende der Zunft", "Legend of the guild")
# Abrechnung
t("UI_SETTLEMENT", "Abrechnung", "Settlement")
t("SET_HIT_QUOTE", "Trefferquote im Zielfenster", "Blows in the target window")
t("SET_DAMAGE", "Gefügeschaden (Ø)", "Structural damage (avg.)")
t("SET_QUENCH", "Abzug durch Härten", "Hardening penalty")
t("SET_QUALITY", "Qualitätswert Q", "Quality value Q")
t("SET_LATE", "Verspätet geliefert (halber Lohn, kein Trinkgeld)", "Delivered late (half pay, no tip)")
t("SET_WAGE", "Lohn", "Pay")
t("SET_TIP", "Trinkgeld", "Tip")
t("SET_WAGE_OF", "Lohn {who}", "Wage {who}")
t("SET_COSTS", "Material & Betrieb", "Materials & running costs")
t("SET_ALREADY_PAID", "(bereits bezahlt)", "(already paid)")
t("SET_NET", "Gutgeschrieben", "Credited")
# Epochen
t("UI_EPOCH_CHANGE", "Epochenwechsel", "A new era")
t("UI_EPOCH_DONE", "Epoche {e} abgeschlossen!", "Era {e} complete!")
t("UI_PAY_AND_MOVE", "Gebühr zahlen & umziehen", "Pay the fee & move")
t("UI_MISSING", "Es fehlen noch {m}.", "You still need {m}.")
t("UI_FINALE_TITLE", "Euer eigenes Eisenwerk", "Your own ironworks")
t("UI_FINALE_TEXT", "Vom Dorfschmied mit Handhammer und Lehm-Esse zum Herrn eines Stahlwerks mit Dampfhammer: 180 Jahre Schmiedekunst liegen hinter Euch, Euer Lebenswerk ist vollbracht. Die Werkstatt steht Euch weiter offen – im Freien Spiel kommen endlos neue Aufträge.", "From village smith with a hand hammer and clay forge to master of a steelworks with a steam hammer: 180 years of smithing lie behind you, your life's work is done. The workshop remains open – in free play, new orders keep coming.")
EP = [
 ("Die Dorfschmiede", "The Village Smithy", "", "", "", "",
  "Landwirtschaft und Alltag: Nägel, Hufeisen, Haken, Türangeln, Sicheln und Pflugscharen.", "Farming and everyday life: nails, horseshoes, hooks, hinges, sickles and ploughshares."),
 ("Kutschen & Handelswege", "Coaches & Trade Roads", "Pacht der Schmiede an der Poststraße", "Lease of the smithy on the post road",
  "Die Mautstraßen werden ausgebaut, Postkutschen rollen durchs Land. Eine Schmiede an der Poststraße wartet auf Euch.", "The turnpikes are spreading and mail coaches roll across the land. A smithy on the post road awaits you.",
  "Ihr habt die Schmiede an der Poststraße gepachtet. Kutscher und Postmeister brauchen Radreifen, Achsen und Beschläge – oft gleich mehrere Stück und manchmal in Eile. Eine Ziegel-Esse mit zwei Plätzen und ein Lehrling helfen dabei.",
  "You have leased the smithy on the post road. Coachmen and postmasters need tyres, axles and fittings – often several at once, and sometimes in a hurry. A brick forge with two places and an apprentice will help."),
 ("Hafen & Royal Navy", "Harbour & Royal Navy", "Werkstatt im Hafen, Lizenz der Admiralität", "Harbour workshop, Admiralty licence",
  "Die Flotte wächst. Im Hafen sucht man Schmiede, die Ketten und Anker im Feuer schweißen können.", "The fleet is growing. The harbour needs smiths who can forge-weld chains and anchors.",
  "Eure neue Werkstatt liegt am Hafen. Ketten, Anker und Bootshaken müssen feuergeschweißt werden: Bei halber Arbeit braucht das Eisen Weißglut (1200–1300 °C). Ein Zuschläger mit dem Vorschlaghammer beschleunigt die Arbeit.",
  "Your new workshop lies on the harbour. Chains, anchors and boathooks must be forge-welded: halfway through, the iron needs white heat (1200–1300 °C). A striker with a sledgehammer speeds up the work."),
 ("Stahl & Tuch", "Steel & Cloth", "Aufnahme in die Schmiedegilde, Meisterbrief", "Admission to the smiths' guild, master's certificate",
  "Huntsmans Tiegelstahl aus Sheffield und die ersten Spinnmaschinen verlangen nach gehärtetem Werkzeug.", "Huntsman's Sheffield crucible steel and the first spinning machines call for hardened tools.",
  "Mit dem Meisterbrief der Gilde fertigt Ihr nun Klingen, Federn und Werkzeuge. Nach dem Schmieden werden sie im Löschtrog gehärtet – am besten bei Kirschrot (760–840 °C). Ein Geselle arbeitet für Euch, sogar während Ihr ruht.",
  "With the guild's master certificate you now make blades, springs and tools. After forging they are hardened in the quench trough – best at cherry red (760–840 °C). A journeyman works for you, even while you rest."),
 ("Das Zeitalter des Dampfes", "The Age of Steam", "Übernahme eines Hammerwerks mit Wasserrad", "Taking over a water-powered hammer mill",
  "Watts Dampfmaschine, Gruben und Kanäle: Ein Hammerwerk mit Wasserrad steht zum Verkauf.", "Watt's steam engine, mines and canals: a hammer mill with a water-wheel is for sale.",
  "Ihr habt ein Hammerwerk mit Wasserrad übernommen. Ein Wasser-Schwanzhammer schlägt von selbst mit, solange ein Werkstück auf dem Amboss liegt – je nach Wasserstand mit 60 bis 100 % Kraft. Die Koks-Esse heizt schneller und heißer als alles zuvor.",
  "You have taken over a hammer mill with a water-wheel. A water-powered helve strikes on its own while a piece lies on the anvil – at 60 to 100 % power depending on the water level. The coke forge heats faster and hotter than anything before."),
 ("Das Zeitalter der Eisenwerke", "The Age of Ironworks", "Beteiligung an einem Eisenwerk", "A share in an ironworks",
  "Corts Puddelverfahren macht Schmiedeeisen massenhaft verfügbar. Ein Eisenwerk sucht Teilhaber.", "Cort's puddling process makes wrought iron plentiful. An ironworks is looking for partners.",
  "Als Teilhaber eines Eisenwerks schmiedet Ihr Wellen, Achsen und Kesselteile. Großschmiedestücke sind zu schwer für den Handhammer – hier arbeitet vor allem der Dampf-Schwanzhammer, Ihr steuert Hitze und Abläufe. Dampf kostet Kohle: 5s je Betriebsminute.",
  "As a partner in an ironworks you forge shafts, axles and boiler parts. Heavy forgings are too much for the hand hammer – the steam helve does most of the work while you manage heat and timing. Steam costs coal: 5s per minute of operation."),
 ("Krieg & Erfindergeist", "War & Invention", "Pacht einer Maschinenschmiede in Lambeth", "Lease of an engineering smithy in Lambeth",
  "Napoleon sperrt den Kontinent, die Navy braucht Eisen, und in London baut Maudslay Maschinen, die Maschinen bauen.", "Napoleon blockades the Continent, the Navy needs iron, and in London Maudslay builds machines that build machines.",
  "Eure neue Schmiede liegt in Lambeth, Tür an Tür mit Henry Maudslays Werkstatt. Die Royal Navy bestellt in großen Mengen, Telford braucht Eisen für Kanäle und Brücken, und London bekommt Gaslaternen. Ein Heizer hält Eure Esse heißer – und Maudslays Präzisionsaufträge verlangen die richtige Schlagstärke für jeden Arbeitsgang.",
  "Your new smithy is in Lambeth, next door to Henry Maudslay's workshop. The Royal Navy orders in bulk, Telford needs iron for canals and bridges, and London is getting gas lamps. A stoker keeps your fire hotter – and Maudslay's precision orders demand the right blow strength for every step."),
 ("Eisenbahnfieber", "Railway Mania", "Eine Schmiede bei Robert Stephenson & Co. in Newcastle", "A smithy at Robert Stephenson & Co. in Newcastle",
  "1825 fährt der erste Zug von Stockton nach Darlington. Lokomotiven brauchen Achsen, Radreifen und Kupplungen – viele davon.", "In 1825 the first train runs from Stockton to Darlington. Locomotives need axles, tyres and couplings – lots of them.",
  "Newcastle ist das Herz des Lokomotivbaus. Ihr schmiedet in Serie: Schienennägel, Kupplungen, Radreifen, Treibstangen und schwere Kurbelachsen. Der neue Schweißofen erreicht 1500 °C und heizt schneller als jede Esse zuvor.",
  "Newcastle is the heart of locomotive building. You forge in series: track spikes, couplings, tyres, connecting rods and heavy crank axles. The new welding furnace reaches 1500 °C and heats faster than any forge before."),
 ("Der Dampfhammer", "The Steam Hammer", "Partnerschaft mit der Bridgewater Foundry in Patricroft", "Partnership with the Bridgewater Foundry at Patricroft",
  "James Nasmyth hat einen Hammer erfunden, den Dampf hebt und fallen lässt – fein genug für ein Ei, stark genug für eine Schiffswelle.", "James Nasmyth has invented a hammer lifted and dropped by steam – gentle enough for an egg, strong enough for a ship's shaft.",
  "In Patricroft arbeitet Ihr mit Nasmyths Dampfhammer. Anders als der Schwanzhammer schlägt er mit genau der Stärke, die Ihr wählt – und arbeitet deshalb in jedem Arbeitsgang mit. Brunels „Great Britain“, die Britannia-Brücke und der Kristallpalast warten auf Eure Schmiedestücke.",
  "At Patricroft you work with Nasmyth's steam hammer. Unlike the helve it strikes with exactly the strength you choose – and therefore works in every step. Brunel's Great Britain, the Britannia Bridge and the Crystal Palace are waiting for your forgings."),
 ("Das Stahlzeitalter", "The Age of Steel", "Ein eigenes Stahlwerk in Sheffield", "A steelworks of your own in Sheffield",
  "Bessemer und Siemens machen Stahl zum Massengut. Panzerschiffe, Ozeandampfer und Eisenbahnen verlangen Stahl in nie gekannten Mengen.", "Bessemer and Siemens make steel a bulk material. Ironclads, ocean liners and railways demand steel as never before.",
  "Euer eigenes Stahlwerk in Sheffield: Der Siemens-Gasofen erreicht 1550 °C, der große Dampfhammer schmiedet Panzerplatten und Wellen für Ozeandampfer. Stahl verlangt engere Fenster und oft das Härten – das Meisterstück Eures Lebens.",
  "Your own steelworks in Sheffield: the Siemens gas furnace reaches 1550 °C, the great steam hammer forges armour plate and shafts for ocean liners. Steel demands narrower windows and often hardening – the masterpiece of your life."),
]
for i, e in enumerate(EP, start=1):
    t(f"EPOCH_{i}_NAME", e[0], e[1])
    if i >= 2:
        t(f"FEE_{i}", e[2], e[3])
        t(f"EPOCH_{i}_TEASER", e[4], e[5])
        t(f"EPOCH_{i}_INTRO", e[6], e[7])
    else:
        t(f"EPOCH_{i}_INTRO", e[6], e[7])
# Tutorial
t("TUT_TITLE", "Lehrzeit", "Apprenticeship")
t("TUT_SKIP", "Überspringen", "Skip")
t("TUT_OPEN_BOOK", "Öffnet das Auftragsbuch [J] und nehmt einen Auftrag an.", "Open the order book [J] and accept an order.")
t("TUT_LOAD", "Legt den Rohling in die Esse: Klickt auf den Rohling-Stapel oder drückt [R].", "Put the blank into the fire: click the stack of blanks or press [R].")
t("TUT_WAIT_HEAT", "Wartet, bis das Eisen kirschrot glüht (ab 700 °C). Die Glutfarben-Skala unten zeigt die Hitze.", "Wait until the iron glows cherry red (700 °C and above). The glow scale below shows the heat.")
t("TUT_TAKE", "Jetzt! Klickt auf das glühende Werkstück, um es auf den Amboss zu legen [E].", "Now! Click the glowing piece to lay it on the anvil [E].")
t("TUT_HAMMER", "Schmiedet! Klickt auf den Amboss oder drückt die Leertaste.", "Forge! Click the anvil or press the space bar.")
t("TUT_TOO_COLD_SOON", "Das Eisen kühlt ab – unter Kirschrot wirken die Schläge schwächer. Zurück in die Esse [E]!", "The iron is cooling – below cherry red your blows are weaker. Back into the fire [E]!")
t("TUT_COLD", "Zu kalt! Kalte Schläge bringen nichts und beschädigen das Gefüge. Zurück ins Feuer [E]!", "Too cold! Cold blows achieve nothing and damage the iron. Back into the fire [E]!")
t("TUT_BUY_HAMMER", "Gut verdient! Kauft im Laden [S] den Kreuzschlaghammer – er schlägt mehr als doppelt so kräftig.", "Well earned! Buy the cross-peen hammer in the shop [S] – it strikes more than twice as hard.")
# Hinweise zu neuen Mechaniken
H = {
 "welcome": ("Willkommen in der Dorfschmiede", "Ein Werkstück wird in mehreren Hitzen fertig: in der Esse aufheizen, auf dem Amboss schmieden, solange es glüht, zurück ins Feuer, wieder schmieden. Das Timing zwischen Esse und Amboss ist Eure wichtigste Fertigkeit.\n\nZu kalt (unter 400 °C) beschädigt das Eisen, zu heiß (über 1100 °C) ebenso – über 1300 °C verbrennt es.",
             "Welcome to the village smithy", "A piece is finished over several heats: heat it in the forge, forge it on the anvil while it glows, back into the fire, forge again. Timing between forge and anvil is your most important skill.\n\nToo cold (below 400 °C) damages the iron, too hot (above 1100 °C) as well – above 1300 °C it burns."),
 "precision": ("Präzisionsauftrag", "Hier zählt nur, was Ihr im engen Zielfenster von 850–1000 °C schmiedet. Drei Sterne bringen 25 % Trinkgeld.",
               "Precision order", "Only what you forge in the narrow window of 850–1000 °C counts here. Three stars earn a 25 % tip."),
 "quantity": ("Mengenauftrag", "Mehrere Stücke: Jedes wird einzeln erhitzt und geschmiedet. Nutzt alle Plätze der Esse, damit die nächsten Stücke schon heizen, während Ihr schmiedet.",
              "Quantity order", "Several pieces: each is heated and forged on its own. Use every place in the forge so the next pieces are heating while you work."),
 "rush": ("Eilauftrag", "Die Sanduhr läuft ab Annahme. Pünktlich gibt es 50 % mehr Lohn; verspätet nur die Hälfte und kein Trinkgeld.",
          "Rush order", "The hourglass runs from acceptance. On time pays 50 % more; late pays only half and no tip."),
 "weld": ("Feuerschweißen", "Bei halber Arbeit hält der Fortschritt an: Setzt 6 Schläge bei Weißglut (1200–1300 °C). Schläge außerhalb zählen nicht – und in dieser Hitze leidet das Gefüge, also schnell und genau!",
          "Forge welding", "Halfway through, progress pauses: strike 6 blows at white heat (1200–1300 °C). Blows outside don't count – and the iron suffers at this heat, so be quick and precise!"),
 "harden": ("Härten", "Ist das Stück fertig geschmiedet, zieht Ihr es in den Löschtrog [Q]. Bewertet wird die Temperatur beim Abschrecken: 760–840 °C ist richtig, darüber droht ein Härteriss, darunter bleibt es zu weich. Zu kalt? Einfach nachheizen.",
            "Hardening", "Once the piece is fully forged, put it into the quench trough [Q]. The temperature when quenching counts: 760–840 °C is right; hotter risks a quench crack, cooler leaves it too soft. Too cold? Just reheat it."),
 "machine": ("Maschinenbetrieb", "Eure Maschine schlägt automatisch mit, solange ein Werkstück mit mindestens 400 °C auf dem Amboss liegt – zusätzlich zu Euren eigenen Schlägen.",
             "Machine power", "Your machine strikes automatically while a piece of at least 400 °C lies on the anvil – in addition to your own blows."),
 "big": ("Großschmiedestück", "Zu schwer für den Handhammer: Eure Schläge wirken nur zu 25 %. Den Großteil leistet die Maschine – Ihr haltet das Eisen in der richtigen Hitze.",
         "Heavy forging", "Too heavy for the hand hammer: your blows count only 25 %. The machine does most of the work – you keep the iron at the right heat."),
 "journeyman": ("Der Geselle", "Euer Geselle arbeitet im Hintergrund eigene Aufträge ab – auch wenn das Spiel geschlossen ist (bis zu 8 Stunden).",
                "The journeyman", "Your journeyman works his own orders in the background – even while the game is closed (up to 8 hours)."),
}
for k, v in H.items():
    t(f"HINT_{k.upper()}_TITLE", v[0], v[2])
    t(f"HINT_{k.upper()}_TEXT", v[1], v[3])

# ---------------------------------------------------------------- Arbeitsgänge & Werkstoffe
for k, de, en in (("DRAW", "Strecken", "Drawing out"), ("UPSET", "Stauchen", "Upsetting"), ("FLATTEN", "Breiten", "Spreading"),
                  ("POINT", "Anspitzen", "Pointing"), ("PUNCH", "Lochen", "Punching"), ("BEND", "Biegen", "Bending"),
                  ("TWIST", "Verdrehen", "Twisting"), ("CUT", "Spalten", "Splitting"), ("PLANISH", "Schlichten", "Planishing")):
    t("STEP_" + k, de, en)
t("MAT_IRON", "Schmiedeeisen", "Wrought iron")
t("MAT_STEEL", "Stahl", "Steel")
t("UI_STEP_INFO", "Arbeitsgang {k}/{n}: {step} ({lo}–{hi} °C)", "Step {k}/{n}: {step} ({lo}–{hi} °C)")
t("FX_NEXT_STEP", "Nächster Arbeitsgang: {step} ({lo}–{hi} °C)", "Next step: {step} ({lo}–{hi} °C)")
t("FX_WRONG_HEAT", "Falsche Hitze für diesen Arbeitsgang", "Wrong heat for this step")
t("TUT_TOO_HOT", "Noch zu heiß für diesen Arbeitsgang – lasst das Eisen kurz abkühlen, bis der Zeiger im hellen Zielfenster steht.", "Still too hot for this step – let the iron cool a moment until the pointer is inside the bright target window.")
S["TUT_WAIT_HEAT"] = ("Wartet, bis das Eisen die Hitze des Arbeitsgangs erreicht: Der Zeiger der Glutfarben-Skala muss im hellen Zielfenster stehen.", "Wait until the iron reaches the heat for this step: the pointer on the glow scale must be inside the bright target window.")
S["TUT_TAKE"] = ("Jetzt! Klickt auf das glühende Werkstück, um es auf den Amboss zu legen [E].", "Now! Click the glowing piece to lay it on the anvil [E].")
S["TUT_TOO_COLD_SOON"] = ("Zu kühl für diesen Arbeitsgang – Schläge zählen nicht für die Qualität. Zurück in die Esse [E]!", "Too cool for this step – blows don't count towards quality. Back into the fire [E]!")
t("HINT_STEPS_TITLE", "Arbeitsgänge", "Working steps")
t("HINT_STEPS_TEXT", "Jedes Stück entsteht in mehreren Arbeitsgängen, jeder mit eigener Hitze: Strecken bei Gelbglut, Biegen und Lochen bei Kirschrot, Schlichten bei dunkler Glut. Das helle Zielfenster auf der Glutfarben-Skala zeigt die richtige Hitze für den aktuellen Arbeitsgang, die Abschnitte über dem Fortschrittsbalken zeigen, was noch kommt.\n\nTipp: Oft lässt sich ein Stück im Abkühlen vom einen in den nächsten Arbeitsgang schmieden.",
  "Every piece is made in several steps, each with its own heat: drawing out at yellow heat, bending and punching at cherry red, planishing at a dull glow. The bright target window on the glow scale shows the right heat for the current step; the sections above the progress bar show what comes next.\n\nTip: a piece can often be worked from one step into the next as it cools.")
t("HINT_STEEL_TITLE", "Stahl", "Steel")
t("HINT_STEEL_TEXT", "Stahl wird kühler geschmiedet als Schmiedeeisen: Alle Zielfenster liegen 50 °C tiefer, und Stahl verbrennt schon ab 1250 °C. Lasst ihn nicht zu lange im Feuer!",
  "Steel is forged cooler than wrought iron: every target window lies 50 °C lower, and steel burns from 1250 °C. Don't leave it in the fire too long!")
S["HINT_QUANTITY_TEXT"] = ("Mehrere Stücke: Jedes wird einzeln erhitzt und geschmiedet. Nutzt alle Plätze der Esse, damit die nächsten Stücke schon heizen, während Ihr schmiedet.\n\nWird das Stück auf dem Amboss zu kalt, tauscht Ihr es mit [E] oder per Klick auf ein heißes Stück in der Esse.",
  "Several pieces: each is heated and forged on its own. Use every place in the forge so the next pieces are heating while you work.\n\nWhen the piece on the anvil gets too cold, swap it with [E] or by clicking a hot piece in the forge.")
S["HINT_WELCOME_TEXT"] = ("Ein Werkstück wird in mehreren Hitzen fertig: in der Esse aufheizen, auf dem Amboss schmieden, solange es die richtige Glut hat, zurück ins Feuer, wieder schmieden. Das Timing zwischen Esse und Amboss ist Eure wichtigste Fertigkeit.\n\nZu kalt (unter 400 °C) beschädigt das Eisen, zu heiß (über 1100 °C) ebenso – über 1300 °C verbrennt es.",
  "A piece is finished over several heats: heat it in the forge, forge it on the anvil while it has the right glow, back into the fire, forge again. Timing between forge and anvil is your most important skill.\n\nToo cold (below 400 °C) damages the iron, too hot (above 1100 °C) as well – above 1300 °C it burns.")

# ---------------------------------------------------------------- Testmenü
t("TEST_TITLE", "Testmenü", "Test menu")
t("TEST_INFO", "Epoche {e} · Auftrag {n} von {total} · Komplexität {c} · Münzbeutel {m}", "Era {e} · order {n} of {total} · complexity {c} · purse {m}")
t("TEST_EPOCHS", "In eine Epoche springen", "Jump to an era")
t("TEST_EPOCHS_NOTE", "Setzt das laufende Spiel auf den gewählten Stand: Meilensteine davor gelten als erledigt, Ausrüstung und Personal der Epoche werden ergänzt. Geld bleibt erhalten. Vorher bei Bedarf in einem Test-Spielstand sichern.", "Sets the current game to the chosen point: earlier milestones count as done, the era's equipment and staff are added. Money is kept. Save to a test slot first if needed.")
t("TEST_START", "Anfang", "Start")
t("TEST_MIDDLE", "Mitte", "Middle")
t("TEST_END", "Ende", "End")
t("TEST_QUICK", "Schnellaktionen", "Quick actions")
t("TEST_FINISH_JOB", "Auftrag fertig (3 Sterne)", "Finish order (3 stars)")
t("TEST_REROLL", "Neue Angebote sofort", "New offers now")
t("TEST_SPEED", "Spieltempo:", "Game speed:")
t("TEST_SLOTS", "Test-Spielstände", "Test saves")
t("TEST_SLOT_EMPTY", "Platz {i}: leer", "Slot {i}: empty")
t("TEST_SLOT_INFO", "Platz {i}: Epoche {e}, Auftrag {n}, {m} – {date}", "Slot {i}: era {e}, order {n}, {m} – {date}")
t("TEST_SAVE", "Speichern", "Save")
t("TEST_LOAD", "Laden", "Load")
t("TEST_DELETE", "Löschen", "Delete")
t("TEST_NEW_GAME", "Neues Spiel starten", "Start a new game")
S["TYPE_PRECISION"] = ("Präzision (enges Fenster)", "Precision (narrow window)")
S["HINT_PRECISION_TEXT"] = ("Hier zählt nur, was Ihr in der Mitte des Zielfensters schmiedet: Jedes Fenster ist auf seine mittleren 60 % verengt. Drei Sterne bringen 25 % Trinkgeld.", "Only what you forge in the middle of the target window counts here: every window is narrowed to its central 60 %. Three stars earn a 25 % tip.")
# Schlagstärke
t("FORCE_0", "Leicht", "Light")
t("FORCE_1", "Mittel", "Medium")
t("FORCE_2", "Schwer", "Heavy")
t("FORCE_0_LC", "leicht", "light")
t("FORCE_1_LC", "mittel", "medium")
t("FORCE_2_LC", "schwer", "heavy")
t("UI_FORCE_TIP", "Schlagstärke (Pfeiltasten ↑ / ↓)", "Blow strength (arrow keys ↑ / ↓)")
t("FX_TOO_HARD", "Zu fest!", "Too hard!")
t("FX_TOO_SOFT", "Zu sanft!", "Too soft!")
t("HINT_FORCE_TITLE", "Schlagstärke", "Blow strength")
t("HINT_FORCE_TEXT", "Ab jetzt zählt auch, wie fest Ihr zuschlagt. Über dem Hammer-Knopf wählt Ihr Leicht, Mittel oder Schwer (am Rechner auch mit den Pfeiltasten ↑ und ↓).\\n\\nStrecken, Stauchen und Lochen brauchen schwere Schläge, Biegen, Verdrehen und Schlichten leichte. Neben dem Zielfenster seht Ihr, was der aktuelle Arbeitsgang verlangt.\\n\\nZu sanft kostet Zeit – zu fest beschädigt das Werkstück.", "From now on it also matters how hard you strike. Above the hammer button choose Light, Medium or Heavy (arrow keys ↑ and ↓ on a computer).\\n\\nDrawing out, upsetting and punching need heavy blows; bending, twisting and planishing need light ones. Next to the target window you can see what the current step requires.\\n\\nToo soft costs time – too hard damages the piece.")
t("HINT_FORCE_MEDIUM_TITLE", "Mittlere Schläge", "Medium blows")
t("HINT_FORCE_MEDIUM_TEXT", "In der neuen Werkstatt verlangen Breiten, Spitzen und Abschroten mittlere Schläge – nicht mehr die volle Wucht.", "In the new workshop, spreading, pointing and cutting need medium blows – no longer full force.")
t("UI_STEAM_WAITS", "Dampfhammer wartet – Schlagstärke zu hoch", "Steam hammer waiting – blow too heavy")
# Werkstatt-Einrichtung (scripts/furnishings.gd)
t("UI_SECTION_FURNISH", "Einrichtung der Werkstatt", "Workshop fittings")
t("UI_FURNISH_NOTE", "Jede Werkstatt hat fünf Plätze. Mit dem Umzug in die nächste Epoche beginnt die Einrichtung von vorn. Sind alle fünf eingerichtet, zahlt die Zunft eine Prämie von {bonus}.", "Every workshop has five places. When you move on to the next era, you furnish the new workshop from scratch. Once all five are fitted out, the guild pays a bonus of {bonus}.")
t("UI_FURNISHED", "Eingerichtet", "Fitted")
t("FURN_SLOT_FUEL", "Brennstoff", "Fuel")
t("FURN_SLOT_TOOLS", "Werkzeugwand", "Tool wall")
t("FURN_SLOT_BENCH", "Werkbank", "Workbench")
t("FURN_SLOT_TRADE", "Kundschaft", "Custom")
t("FURN_SLOT_LIGHT", "Licht und Lager", "Light and stores")
t("FURN_FX_FUEL", "Esse heizt 15 % schneller", "Forge heats 15 % faster")
t("FURN_FX_TOOLS", "+10 % Fortschritt je Schlag", "+10 % progress per blow")
t("FURN_FX_TOOLS_BIG", "+10 % Fortschritt je Schlag, große Stücke deutlich leichter", "+10 % progress per blow, large pieces much easier")
t("FURN_FX_BENCH", "Zielfenster 25 °C breiter, 20 % weniger Gefügeschaden", "Target window 25 °C wider, 20 % less damage")
t("FURN_FX_TRADE", "4 statt 3 Angebote, neue Angebote schon nach 30 s", "4 instead of 3 offers, new offers after just 30 s")
t("FURN_FX_LIGHT", "Lohn +5 %, halber Materialverlust bei Ausschuss", "Pay +5 %, half the material loss on scrap")
t("MSG_FURNISHED", "Werkstatt vollständig eingerichtet! Prämie der Zunft: {bonus}", "Workshop fully fitted out! Guild bonus: {bonus}")
t("HINT_FURNISH_TITLE", "Einrichtung", "Fittings")
t("HINT_FURNISH_TEXT", "Euer erstes Einrichtungsstück steht! Jedes der fünf Stücke hilft auf seine Weise – und wenn die Werkstatt vollständig eingerichtet ist, zahlt die Zunft eine Prämie.", "Your first fitting is in place! Each of the five pieces helps in its own way – and once the workshop is fully fitted out, the guild pays a bonus.")
t("STAT_FURNISHED", "Vollständig eingerichtete Werkstätten", "Workshops fully fitted out")

import os as _os, re as _re
_src = open(_os.path.join(_os.path.dirname(_os.path.abspath(__file__)), "..", "..", "scripts", "furnishings.gd"), encoding="utf-8").read()
for _e, _body in _re.findall(r"^\t(\d+): \{(.*?)\},$", _src, _re.S | _re.M):
    for _slot, _de, _en in _re.findall(r'"(\w+)": \["([^"]*)", "([^"]*)"\]', _body):
        t(f"FURN_E{_e}_{_slot.upper()}", _de, _en)
t("UI_SETTLE_MENU", "Menü", "Menu")
t("UI_REPEAT_JOB", "Auftrag wiederholen", "Repeat order")
