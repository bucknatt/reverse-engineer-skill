# PHP source profile

Use this profile only when the inventory shows PHP. Do not apply it to another language.

## Detect the framework

Read `composer.json` when it exists. Match packages before reading application code:

- `laravel/framework` — Laravel
- `symfony/framework-bundle` or `symfony/flex` — Symfony
- `laminas/laminas-mvc` or `mezzio/mezzio` — Laminas or Mezzio
- None of those — plain PHP, including a Composer autoloader with no framework

Record the PHP version from `composer.json` `require.php` when present, otherwise from a runtime constraint the project documents. Do not guess a version.

Ignore `vendor/`. Read `.env.example` or documented key names. Do not read `.env` values.

## Where to look

### Laravel

- Entry: `public/index.php`, `artisan`
- Routes: `routes/web.php`, `routes/api.php`, `routes/console.php`
- HTTP: `app/Http/Controllers`, `app/Http/Middleware`, `app/Http/Requests`
- Rules and state: `app/Models`, `app/Actions`, `app/Services`, `app/Policies`
- UI: `resources/views`, plus any JS or CSS the inventory listed
- Store: `database/migrations`, `database/factories`, `app/Models`
- Jobs: `app/Jobs`, `app/Console`, `routes/console.php`

### Symfony

- Entry: `public/index.php`, `bin/console`
- Routes: `config/routes.yaml`, `config/routes/`, attributes on controllers
- HTTP: `src/Controller`
- Rules and state: `src/Entity`, `src/Service`, `src/Security`
- UI: `templates/`
- Store: Doctrine mappings and `migrations/`
- Jobs: Messenger handlers, `config/packages/messenger.yaml`

### Laminas or Mezzio

- Entry: `public/index.php`
- Modules: `module/*/config`, `config/autoload`, `config/routes.php`
- HTTP: `*Controller.php`, middleware pipelines
- Store: the adapter and SQL files the module config names

### Plain PHP

- Entry candidates: `index.php`, `public/index.php`, a front controller the inventory listed
- Follow `include` and `require` from that entry
- Record SQL strings, form handlers, and session keys on those paths
- Absence of a framework package is a finding. It is not a reason to invent layers

## Sessions, auth, and side effects

Record the mechanism with a citation: session keys, guards or middleware, password storage call, mail, filesystem writes, and outbound HTTP. These feed the auth proposal later. Do not propose the replacement in this profile.

## Oracle

A local run uses the project’s documented server command and a synthetic database. Record the command in `04-oracle.md`. Skip the run when it would need secrets or production data, and mark the rows `unverified-runtime`.
