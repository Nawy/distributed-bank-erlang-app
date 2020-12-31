##The basic My Bank example in erlang
Mybank app is a simple erlang application based on OTP

### Build and Run
You need **build** all sources into `.beam` files.
```shell
erl -o ebin src/*erl
```

Then of course, you want to start it. No problem:

```shell
erl -pa ebin
```

### API

Start bank:
```erlang
mybank:start().
```

Stop bank:
```erlang
mybank:stop().
```

You can deposit money, where the name is atom:
```erlang
mybank:deposit(yourname, 2000).
```

Withdraw money:
```erlang
mybank:withdraw(yourname, 1500).
```

Check your balance:
```erlang
mybank:balance(yourname).
```


