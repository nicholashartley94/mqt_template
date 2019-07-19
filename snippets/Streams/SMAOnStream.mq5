//SMAOnStream v1.0

class SMAOnStream : public AOnStream
{
   double _length;
public:
   SMAOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      double summ = 0;
      for (int i = 0; i < _length; ++i)
      {
         double price[1];
         if (!_source.GetValues(period + i, 1, price))
            return false;
         summ += price[0];
      }
      val = summ / _length;
      return true;
   }
};