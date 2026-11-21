# Troubleshooting

Problems met while setting up and building the lessons of this repository, with
their cause and fix. Environment: Windows 11, PowerShell 5.1, VS Code, Alire with
`gnat_native` and `gprbuild`.

## Toolchain and Windows

### `as.exe`: `CreateProcess: No such file or directory`

```
gcc: fatal error: cannot execute '.../x86_64-w64-mingw32/bin/as.exe': CreateProcess: No such file or directory
```

**Symptom.** Every file fails to compile, including files that built before.
The message comes from `gcc`, before any Ada analysis.

**Cause.** `gcc` cannot start the assembler `as.exe`. The file may exist and still be
blocked by Windows (see Smart App Control below), or be damaged.

**Fix.**

1. Check that the file exists:
   ```powershell
   Test-Path "$env:LOCALAPPDATA\alire\cache\toolchains\gnat_native_<version>\x86_64-w64-mingw32\bin\as.exe"
   ```
2. Look for a blocked or quarantined file in *Windows Security* → *Virus & threat
   protection* → *Protection history*.
3. Reinstall the toolchain:
   ```powershell
   Remove-Item -Recurse -Force "$env:LOCALAPPDATA\alire\cache\toolchains\gnat_native_<version>"
   alr toolchain --select
   ```
   Pick `gnat_native` and `gprbuild` again.

If the error comes back, Smart App Control is the likely cause.

### "An Application Control policy has blocked this file"

```
Program 'ex04_sensor_check.exe' failed to run: An Application Control policy has blocked this file
```

On a French system: *Une stratégie de contrôle d'application a bloqué ce fichier*.
A Microsoft Defender notification may appear at the same time.

**Cause.** Smart App Control, enabled by default on clean installs of Windows 11,
blocks unsigned programs without a known reputation. Every freshly compiled `.exe`
is unsigned and unknown, and the decision relies on an online check, so it can
change from one build to the next. It can also block toolchain programs such as `as.exe`.

**Fix.** Smart App Control accepts no exclusions. On a development machine, turn it
off in *Windows Security* → *App & browser control* → *Smart App Control settings*.
Turning it off is permanent: it can only be turned back on by reinstalling Windows.
Microsoft Defender Antivirus stays active.

### Two `alr` executables on the `PATH`

**Symptom.** `alr` behaves differently between terminals, or reports an unexpected version.

**Cause.** Alire was installed twice (installer, winget, zip archive).

**Fix.** Keep a single installation. `Get-Command alr` shows which one runs.

## Build

### The build is silent, but warnings were expected

**Cause.** Warnings and style messages only appear when a file is compiled.
A build that finds every file up to date compiles nothing.

**Fix.** Force a full rebuild: `alr build -- -f`.

### `alr run` does not start the exercise

**Cause.** `alr run` only runs the executables listed in `alire.toml`.

**Fix.** Run the exercise directly: `.\bin\ex01_type_limits.exe`.

### Casing errors appear only after other errors are fixed

**Cause.** GNAT works in phases. Casing checks (`-gnatyr`) need semantic analysis,
which never runs on a file with syntax errors.

**Fix.** Fix the first error, rebuild, repeat.

## Compiler messages

### `expected type "..."` / `found type "..."`

```
error: no candidate interpretations match the actuals:
error: missing argument for parameter "To" in call to "Set_Col" declared at a-textio.ads:348
error: expected type "Ada.Text_Io.Positive_Count"
error: found type "Standard.Integer"
```

**Cause.** A value of one type is passed where a distinct type is expected.
Ada never converts implicitly. When a subprogram is overloaded, GNAT lists every
candidate, and some messages, such as `missing argument`, are misleading.

**Fix.** Look for the `expected type` / `found type` pair. Declare the value with
the expected type, or convert it explicitly: `Positive_Count (Column)`.

### `could be declared constant`

**Cause.** A variable is never modified after its declaration.

**Fix.** Declare it `constant`.

## Run time

### `raised CONSTRAINT_ERROR`

```
raised CONSTRAINT_ERROR : bad input for 'Value: "  42x"
0x... System.Val_Util.Bad_Value at s-valuti.adb:52
0x... Ex04_Sensor_Check at ex04_sensor_check.adb:8
```

**Cause.** A value does not fit its type: overflow, division by zero, a negative value
stored in a `Natural`, a string that `'Value` cannot read, etc. The build succeeded
because the value was not known at compile time.

**Fix.** The first line says *what* happened; the first line that names one of your
files says *where*. File names and line numbers are shown thanks to the binder
switch `-Es`, set by Alire in the `.gpr` file.

## Files and Git

### File saved in UTF-16 by PowerShell

**Symptom.** GitHub shows the file as binary, or the text is full of strange characters.

**Cause.** In Windows PowerShell 5.1, the redirection `>` and `Out-File` write UTF-16
by default.

**Fix.** Create text files in VS Code, or write them with `Set-Content -Encoding utf8`.
To repair a file, open it in VS Code, click the encoding in the status bar, then
*Save with Encoding* → *UTF-8*.

### No newline at end of file

**Symptom.** GitHub diffs show *No newline at end of file*.

**Fix.** In VS Code, enable *Files: Insert Final Newline* (`files.insertFinalNewline`).

### Fixing the last commit

Before a push, `git commit --amend` replaces the last commit: use it to fix its
message or add a forgotten file. Never amend a commit that is already pushed;
make a new commit instead.
