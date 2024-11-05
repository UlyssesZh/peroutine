# peroutine

Remind you of periodical events.
The period can be any positive integer of days.
(Work around the fact that the number of days in a week is prime!)

## Installation

[Install Ruby](https://www.ruby-lang.org/en/documentation/installation),
and then put the `peroutine` file in a directory in your `$PATH`.
Remember to add execution permission to the file.

## Usage

First, run `peroutine edit` to edit the configuration file.
Here is a sample configuration file:

```yaml
---
- description: Wash hair
  period: 2
  on_command: 'curl -H "Title: Wash hair" -d "Wash your hair today." https://ntfy.sh/peroutine'
  off_command: 'curl -H "Title: Don''t wash hair" -d "Don''t Wash your hair today." https://ntfy.sh/peroutine'
  on_time: 23
  off_time: 23
  one_date: 2022-12-05
- description: Wash clothes
  period: 8
  on_command: 'curl -H "Title: Wash clothes" -d "Wash your clothes today." https://ntfy.sh/peroutine'
  on_time: 9
  one_date: 2022-12-06
```

The configuration file is a list of periodical events.
The period is specified as the number of days.
The `on_command` and `off_command` are the commands to run when the event is on or off today.
The `on_time` and `off_time` are the times to run the commands.
The `one_date` is one date when the event is on.

The `description`, `period`, and `one_date` are required.
Other fields are optional.

You can run `peroutine list` to see all the events, grouped by the status (*on* or *off* today).
For example, with the above configuration file, the output of this command on 2022-12-05 is:

```plain
On today:
Wash hair

Off today:
Wash clothes
```

The `peroutine cronjob` command runs the `on_command` and `off_command` specified in the configuration file
according to the current time and the `on_time` and `off_time`.
This command is intended to be run hourly as a cron job.
For example, you can add the following line to your crontab:

```cron
0 * * * * /path/to/peroutine cronjob
```

You can also run `peroutine env` to edit the env file.
For example, one can use this in the env file:

```sh
ENDPOINT=https://ntfy.sh/peroutine
ntfy() {
	curl -H "Title: $1" -d "$2" $ENDPOINT
}
```

Then, you can simply use something like `ntfy "Wash hair" "Wash your hair today."`
in the `on_command` and `off_command`.
Behind the scenes, the commands are simply concatenated to the env file when executed.

## Docker

You can deploy peroutine with Docker.
First, put `config.yml` in `/path/to/config/config.yml`, and then use the following Docker compose file:

```yaml
services:
  peroutine:
    container_name: peroutine
    image: ulysseszhan/peroutine:master
    volumes:
      - /path/to/config:/root/.local/share/peroutine
    environment:
      TZ: America/Los_Angeles
```

The `TZ` environment variable is important.

If your `config.yml` utilizes some commands that are not available in the Docker image,
you can install it by creating a custom Dockerfile.
Here is an example for adding the `curl` command:

```dockerfile
FROM ulysseszhan/peroutine:master
RUN apk add --no-cache curl
```

Then, replace the `image` field in the Docker compose file with a `build` field.

To have an env file when using Docker,
you need to put the env file in `/path/to/config/env.sh`.

## Tips

You can use [ntfy](https://ntfy.sh) or [libnotify](https://gitlab.gnome.org/GNOME/libnotify) to send notifications
in the `on_command` and `off_command`.
