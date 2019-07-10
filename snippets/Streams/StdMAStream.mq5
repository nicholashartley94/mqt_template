// StdMAStream v1.0

class StdMAStream : public ABaseStream
{
   int _maHandle;
public:
   StdMAStream(string symbol, ENUM_TIMEFRAMES timeframe, const int length, const ENUM_MA_METHOD method, int priceOrHandle)
      :ABaseStream(symbol, timeframe)
   {
      _maHandle = iMA(_symbol, _timeframe, length, 0, method, priceOrHandle);
   }
   ~StdMAStream()
   {
      IndicatorRelease(_maHandle);
   }

   int GetHandle()
   {
      return _maHandle;
   }

   virtual bool GetValues(const int period, const int count, double &val[])
   {
      return CopyBuffer(_maHandle, 0, period, count, val) == count;
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }
};