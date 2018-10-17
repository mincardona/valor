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

class AndAllValor(ConjOn, On = ConjOn, Range) : Valor!On {
    private Valor!ConjOn[] preds;

    public this(Range r) {
        foreach(Valor!ConjOn pred; r) {
            preds ~= pred;
        }
    }

    override public bool validate(On data) {
        bool result = true;
        foreach (pred; preds) {
            result &= pred.validate(data);
            if (!result) {
                return false;
            }
        }
        return true;
    }
}

Valor!On vgt(C, On = C)(C compareTo) {
    return new GreaterThanValor!(C, On)(compareTo);
}

Valor!On vlt(C, On = C)(C compareTo) {
    return new LessThanValor!(C, On)(compareTo);
}

Valor!On vand(LOn, ROn, On = LOn)(Valor!LOn lhs, Valor!ROn rhs) {
    return new AndValor!(LOn, ROn, On)(lhs, rhs);
}

Valor!On vand_all(ConjOn, On = ConjOn)(Valor!ConjOn[] preds ...) {
    return new AndAllValor!(ConjOn, On, typeof(preds))(preds);
}

int main(string[] args) {
    auto v = vgt(0).vand(vlt(2));
    writeln(v.validate(-1));
    writeln(v.validate(0));
    writeln(v.validate(1));
    writeln(v.validate(2));
    writeln(v.validate(3));

    writeln(vand_all(vlt(5), vgt(0), vgt(-1)).validate(2));

    return 0;
}
