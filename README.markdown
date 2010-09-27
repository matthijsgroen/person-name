Person Name
===========
Person name is an active record plugin to add support for full names.
A persons name consists of the following parts: prefix, first_name, middle_name, intercalation, last_name and suffix

If you have to fill in a name for somebody, you have to display all those fields, and fill them in.
The goal is to make one field that can split up the name and assign it to the correct fields automatically.
You can also still use the more precise input if necessary.

Installation
============
in your Gemfile:

    gem "person-name"

Usage
=====

Small gem to insert easy person name behaviour into rails models

migration:

    create_table :people do |t|
        t.person_name :name
        t.person_name :birth_name
        t.boolean :female, :null => true

        t.timestamps
    end

In this case the following fields are created:

    name_prefix
    name_first_name
    name_middle_name
    name_intercalation
    name_last_name
    name_suffix

    birth_name_prefix
    birth_name_first_name
    birth_name_middle_name
    birth_name_intercalation
    birth_name_last_name
    birth_name_suffix

    female
    created_at
    updated_at

model:

    class Person < ActiveRecord::Base

        has_person_name :name, :birth_name

    end


Now put this thing to use:

    p = Person.new
    p.name = "Matthijs Jacobus Groen"
    p.name.first_name # Matthijs
    p.name.middle_name # Jacobus
    p.name.last_name # Groen
    p.name.short_name # M.J. Groen

    p = Person.new
    p.name = "Ariejan de Vroom"
    p.name.first_name # Ariejan
    p.name.intercalation # de
    p.name.last_name # Vroom
    p.name.full_last_name # de Vroom

    p = Person.new
    p.name = "Cornelia Maria Hendrika Damen-van Valkenberg"
    p.name.first_name # Cornelia
    p.name.middle_name # Maria Hendrika
    p.name.last_name # Damen-van Valkenberg

Sometimes, things can go wrong:

    p = Person.new
    p.name = "Yolanthe Cabau van Kasbergen"
    p.name.first_name # Yolanthe
    p.name.middle_name # Cabau
    p.name.intercalation # van
    p.name.last_name # Kasbergen

But, if you correct it, it will remember it:

    p.name.intercalation = nil
    p.name.middle_name = nil
    p.name.last_name = "Cabau van Kasbergen"

    # and now change something:

    p.name = "Yolanthe Truuske Cabau van Kasbergen"
    p.name.first_name # Yolanthe
    p.name.middle_name # Truuske
    p.name.intercalation # nil
    p.name.last_name # Cabau van Kasbergen

