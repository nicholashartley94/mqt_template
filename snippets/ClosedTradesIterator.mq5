// Closed trades iterator v 1.2
#ifndef ClosedTradesIterator_IMP
class ClosedTradesIterator
{
   int _lastIndex;
   int _total;
   ulong _currentTicket;
   string _symbol;

public:
   ClosedTradesIterator()
   {
      _lastIndex = INT_MIN;
   }

   void WhenSymbol(string symbol)
   {
      _symbol = symbol;
   }

   ulong GetTicket() { return _currentTicket; }
   ENUM_DEAL_TYPE GetPositionType() { return (ENUM_DEAL_TYPE)HistoryDealGetInteger(_currentTicket, DEAL_TYPE); }
   string GetSymbol() { return HistoryDealGetString(_currentTicket, DEAL_SYMBOL); }
   datetime GetCloseTime() { return (datetime)HistoryDealGetInteger(_currentTicket, DEAL_TIME); }

   int Count()
   {
      int count = 0;
      for (int i = 0; i < Total(); i--)
      {
         _currentTicket = HistoryDealGetTicket(i);
         if (PassFilter(i))
         {
            count++;
         }
      }
      return count;
   }

   bool Next()
   {
      _total = Total();
      if (_lastIndex == INT_MIN)
         _lastIndex = 0;
      else
         ++_lastIndex;
      while (_lastIndex != _total)
      {
         _total = Total();
         _currentTicket = HistoryDealGetTicket(_lastIndex);
         if (PassFilter(_lastIndex))
            return true;
         ++_lastIndex;
      }
      return false;
   }

   bool Any()
   {
      for (int i = 0; i < Total(); i++)
      {
         _currentTicket = HistoryDealGetTicket(i);
         if (PassFilter(i))
         {
            return true;
         }
      }
      return false;
   }

private:
   int Total()
   {
      bool res = HistorySelect(0, TimeCurrent());
      return HistoryDealsTotal();
   }

   bool PassFilter(const int index)
   {
      long entry = HistoryDealGetInteger(_currentTicket, DEAL_ENTRY);
      if (entry != DEAL_ENTRY_OUT)
      {
         return false;
      }
      if (_symbol != NULL && GetSymbol() != _symbol)
      {
         return false;
      }
      return true;
   }
};
#define ClosedTradesIterator_IMP
#endif