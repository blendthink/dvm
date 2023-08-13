## Commands

### Must not be duplicated

- name

### Format

`^(?<name>[a-z]+)$`

## Options

### KeyOption

#### Must not be duplicated

- name
- abbr

#### Format

- `^-(?<abbr>[a-z])$`
- `^--(?<name>[a-z]{2,})$`

#### Not Supported Format

`^-(?<abbrX>[a-z])(?<abbrY>[a-z])$`

ex)
- `-xy`

- `^--no-(?<name>[a-z]{2,})$`

ex)
- `--no-xx`

### KeyValueOption

#### Must not be duplicated

- name
- abbr

#### Format

- Equals
  - `^-(?<abbr>[a-z])=(?<value>.*)$`
  - `^--(?<name>[a-z]{2,})=(?<value>.*)$`

ex)
- `-x=a`
- `--xx=a`

#### Not Supported Format

##### Space

- `^-(?<abbr>[a-z]) (?<value>.*)$`
- `^--(?<name>[a-z]{2,}) (?<value>.*)$`

ex)
- `-x a`
- `--xx a`

##### Multiple

- `^-(?<abbr>[a-z]) (?<value>.*) -(?<abbr>[a-z]) (?<value>.*)$`
- `^--(?<name>[a-z]{2,}) (?<value>.*) --(?<name>[a-z]{2,}) (?<value>.*)$`

ex)
- `-x a -x b`
- `--xx a --xx b`

### ValueOption

#### Must not be duplicated

Only one can exist in Command.

#### Format

Custom Format

ex)
dvm use 1.0.0
