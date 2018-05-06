## zapish - Zabbix API SHell binding
-----------------------------------

The zapish.inc is the file to include in own SH/bash scripts with few functions which make calling Zabbix API easy.

It consists of few functions for:
* construct JSON string fields like string, numeric and arrays
* the main zabbix_api function which is used to call Zabbix API
* JSON return values parser/extractor
* the zapish_init function which reads ~/.zapish.rc configuration file or initialize if it does not exist

---
At the moment zapish.inc is not fully POSIX SH compliant because it uses in few places "local" keyword to define functions local variables. However, the
intention is to rewrite it to make it fully POSIX SH compliant code.
       
Version: (still not yet) v1.0 rc1

Known bugs:
* None

ToDo:
* replace jq by JSON parser written in SH
* add function to convert regular xml to shell quoted format used configure.import zabbix API
* finish zapish.inc.3.xml documentation
* more test units and examples

------------------------------------
#### License ##
The GNU General Public License Version 2.

#### Copyright (C) 2017-2018 Tomasz Kłoczko <kloczek@fedoraproject.org>

------------------------------------
Note: "zapish" pronunced in English sounds like Polish "zapisz" which means "write it down!" (as commanding)
