
show_details($_/10) for -20..20;

sub show_details {
    my $double = shift;

    my $raw  = pack "d", $double;
    my @bits = reverse unpack "B8"x8, $raw;
    printf "%7.2f = %s\n",$double,join(" ",@bits);
}



__DATA__

// http://blogs.msdn.com/b/ericlippert/archive/2011/02/17/looking-inside-a-double.aspx

using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SolverFoundation.Common;

class Program
{
    static void Main()
    {
        double original = -256.325;
        MyDouble d = original;

        Console.WriteLine("Raw sign: {0}", d.Sign);
        Console.WriteLine("Raw exponent: {0}", d.ExponentBits.Join());
        Console.WriteLine("Raw mantissa: {0}", d.MantissaBits.Join());

        var signchar = d.Sign == 0 ? '+' : '-';

        if (d.Exponent == 0 && d.Mantissa == 0)
        {
            Console.WriteLine("Zero: {0}0", signchar);
            return;
        }
        else if (d.Exponent == 0x7ff && d.Mantissa == 0)
        {
            Console.WriteLine("Infinity: {0}Infinity", signchar);
            return;
        }
        else if (d.Exponent == 0x7ff)
        {
            Console.WriteLine("NaN");
            return;
        }

        bool subnormal = d.Exponent == 0;
        var two = (Rational)2;
        var fraction = subnormal ? Rational.Zero : Rational.One;
        for (int bit = 51; bit >= 0; --bit)
            fraction += d.Mantissa.Bit(bit) * two.Exp(bit - 52);
        fraction = fraction * two.Exp(d.Exponent - 1023);
        if (d.Sign == 1)
            fraction = -fraction;

        Console.WriteLine(subnormal ? "Subnormal" : "Normal");
        Console.WriteLine("Sign: {0}", signchar);
        Console.WriteLine("Exponent: {0}", d.Exponent - 1023);
        Console.WriteLine("Exact binary fraction: {0}.{1}", subnormal ? 0 : 1, d.MantissaBits.Join());
        Console.WriteLine("Nearest approximate decimal: {0}", original);
        Console.WriteLine("Exact rational fraction: {0}", fraction.ToString());
        Console.WriteLine("Exact decimal fraction: {0}", fraction.ToDecimalString());
    }
}

struct MyDouble
{
    private ulong bits;
    public MyDouble(double d)
    {
        this.bits = BitConverter.DoubleToInt64Bits(d);
    }

    public int Sign
    {
        get
        {
            return this.bits.Bit(63);
        }
    }

    public int Exponent
    {
        get
        {
            return (int)this.bits.Bits(62, 52);
        }
    }

    public IEnumerable<int> ExponentBits
    {
        get
        {
            return this.bits.BitSeq(62, 52);
        }
    }

    public ulong Mantissa
    {
        get
        {
            return this.bits.Bits(51, 0);
        }
    }

    public IEnumerable<int> MantissaBits
    {
        get
        {
            return this.bits.BitSeq(51, 0);
        }
    }

    public static implicit operator MyDouble(double d)
    {
        return new MyDouble(d);
    }
}

static class Extensions
{
    public static int Bit(this ulong x, int bit)
    {
        return (int)((x >> bit) & 0x01);
    }

    public static ulong Bits(this ulong x, int high, int low)
    {
        x <<= (63 - high);
        x >>= (low + 63 - high);
        return x;
    }

    public static IEnumerable<int> BitSeq(this ulong x, int high, int low)
    {
        for(int bit = high; bit >= low; --bit)
            yield return x.Bit(bit);
    }

    public static Rational Exp(this Rational x, int y)
    {
        Rational result;
        Rational.Power(x, y, out result);
        return result;
    }

    public static string ToDecimalString(this Rational x)
    {
        var sb = new StringBuilder();
        x.AppendDecimalString(sb, 50000);
        return sb.ToString();
    }

    public static string Join<T>(this IEnumerable<T> seq)
    {
        return string.Concat(seq);
    }
}
