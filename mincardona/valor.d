module mincardona.valor;

import std.stdio;

abstract class Valor(T)
{
    public bool validate(T data);
}

class LessThanValor(T, C) : Valor!T
{
    private C compareTo;

    public this(C compareTo)
    {
        this.compareTo = compareTo;
    }

    override public bool validate(T data)
    {
        return data < compareTo;
    }
}

class GreaterThanValor(T, C) : Valor!T
{
    private C compareTo;

    public this(C compareTo)
    {
        this.compareTo = compareTo;
    }

    override public bool validate(T data) {
        return data > compareTo;
    }
}

class AndValor(T, L, R) : Valor!T
{
    private Valor!L lhs;
    private Valor!R rhs;

    public this(Valor!L lhs, Valor!R rhs)
    {
        this.lhs = lhs;
        this.rhs = rhs;
    }

    override public bool validate(T data) {
        return lhs.validate(data) && rhs.validate(data);
    }
}

Valor!T v_gt(T = C, C)(C compareTo) {
    return new GreaterThanValor!(T, C)(compareTo);
}

Valor!T v_lt(T = C, C)(C compareTo) {
    return new LessThanValor!(T,C)(compareTo);
}

Valor!T v_and(T = L, L, R)(Valor!L lhs, Valor!R rhs) {
    return new AndValor!(T, L, R)(lhs, rhs);
}

int main(string[] args) {
    //auto v = new GreaterThanValor!(int,int)(0).v_and!int(new LessThanValor!(int,int)(2));
    auto v = v_gt!int(0).v_and!int(v_lt!int(2));
    writeln(v.validate(-1));
    writeln(v.validate(0));
    writeln(v.validate(1));
    writeln(v.validate(2));
    writeln(v.validate(3));
    return 0;
}
