## zapish - Zabbix API SHell binding
-----------------------------------

The zapish.inc is file to include in onw SH/bash scripts with few functions
which makes calling zabbix API easy.

It consist from few functions for:
* construct json string fields like string, numeric and arrays
* the main zabbix_api function which is used to call zabbix API
* json return values parser/extractor
* the zapish_init function which reds ~/.zapish.rc configuration file or
  initializes if it does not exist

-----------------------------------
### At the moment zapish.inc is not fully POSIX SH compliant because it uses in
few places local keyword which is used to define functions local variables. 
However my intention is to rewrite it to make it fully POSIX SH compliant
code.
-----------------------------------

Version: (still not yet) v1.0 rc1

Known bugs:
* None

ToDo:
* replace jq by json parser written in SH
* add function to convert regular xml to shell quoted format used configure.import zabbix API
* finish zapish.xml documentation
* more test units and examples

------------------------------------
## License ##
the GNU General Public License Version 2.

------------------------------------
Note: "zapish" pronunced in English sounds like Polish "zapisz" which means "write it down!" (as commanding)
