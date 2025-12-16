# Kata 49: The Translator (i18n)

## Overview
Internationalization (i18n) allows your app to support multiple languages.
Phoenix uses Gettext for translations.

## Key Concepts

### 1. Gettext Basics
Define translations in `.po` files:
```
# priv/gettext/en/LC_MESSAGES/default.po
msgid "welcome"
msgstr "Welcome"

# priv/gettext/es/LC_MESSAGES/default.po
msgid "welcome"
msgstr "Bienvenido"
```

### 2. Using Translations
```elixir
import MyAppWeb.Gettext
gettext("welcome")  # => "Welcome" or "Bienvenido"
```

### 3. Locale Switching
Store locale in assigns and use it:
```elixir
Gettext.put_locale(MyAppWeb.Gettext, locale)
```

### 4. Simplified Demo
For this kata, we'll use a simple map-based approach instead of full Gettext setup.
