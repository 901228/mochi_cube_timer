# cube_timer

The timer logic and database of Mochi Cube Timer: the timer bloc, inspection and alert settings, and the drift database (sessions, solves, settings) with its migrations.

```sh
dart run build_runner build --delete-conflicting-outputs   # after changing a table or dao
dart run drift_dev make-migrations                         # after changing the schema version
dart test
```
