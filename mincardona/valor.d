module mincardona.valor;

import std.stdio;

abstract class Valor(On)
{
    public bool validate(On data);
}

class LessThanValor(C, On = C) : Valor!On
{
    private C compareTo;

    public this(C compareTo)
    {
        this.compareTo = compareTo;
    }

    override public bool validate(On data)
    {
        return data < compareTo;
    }
}

class GreaterThanValor(C, On = C) : Valor!On
{
    private C compareTo;

    public this(C compareTo)
    {
        this.compareTo = compareTo;
    }

    override public bool validate(On data) {
        return data > compareTo;
    }
}

class AndValor(LOn, ROn, On = LOn) : Valor!On
{
    private Valor!LOn lhs;
    private Valor!ROn rhs;

    public this(Valor!LOn lhs, Valor!ROn rhs)
    {
        this.lhs = lhs;
        this.rhs = rhs;
    }

    override public bool validate(On data) {
        return lhs.validate(data) && rhs.validate(data);
    }
}

Valor!On v_gt(C, On = C)(C compareTo) {
    return new GreaterThanValor!(C, On)(compareTo);
}

Valor!On v_lt(C, On = C)(C compareTo) {
    return new LessThanValor!(C, On)(compareTo);
}

Valor!On v_and(LOn, ROn, On = LOn)(Valor!LOn lhs, Valor!ROn rhs) {
    return new AndValor!(LOn, ROn, On)(lhs, rhs);
}

int main(string[] args) {
    auto v = v_gt(0).v_and(v_lt(2));
    writeln(v.validate(-1));
    writeln(v.validate(0));
    writeln(v.validate(1));
    writeln(v.validate(2));
    writeln(v.validate(3));
    return 0;
}
