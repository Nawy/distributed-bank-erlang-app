{application, mybank,
  [
    {description, ""},
    {vsn, "0.1.0"},
    {registered, [
      mybank_atm,
      mybank_sup
    ]},
    {applications, [kernel, stdlib]},
    {mod, {mybank_app, []}},
    {env, []}
  ]
}.
