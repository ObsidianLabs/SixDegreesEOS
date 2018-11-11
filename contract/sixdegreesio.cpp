#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
#include <eosiolib/asset.hpp>

using namespace eosio;

#define EOSIO_DISPATCH_WITH_TRANSFER(TYPE, MEMBERS) \
extern "C" { \
  void apply (uint64_t receiver, uint64_t code, uint64_t action) { \
    if (code == receiver) { \
      switch (action) { \
        EOSIO_DISPATCH_HELPER(TYPE, MEMBERS) \
      } \
    } else if (code == name("eosio.token").value && action == name("transfer").value) { \
      execute_action(name(receiver), name(code), &TYPE::eostransfer); \
    } \
  } \
}

CONTRACT sixdegreesio : public contract {
  public:
    using contract::contract;
    sixdegreesio(eosio::name receiver, eosio::name code, datastream<const char*> ds):contract(receiver, code, ds) {}
    
    ACTION eostransfer(name from, name to, asset quantity, std::string memo) {
      if (from == _self || to != _self) {
        return;
      }
      
      cases cs(_self, from.value);
      cs.emplace(_self, [&](auto& row) {
        row.id = cs.available_primary_key();
        row.rewarded = false;
        row.account = from;
        row.reward = quantity;
        row.desc = memo;
      });
    }
    
    ACTION cancel(name account, uint64_t id) {
      require_auth(account);
      cases cs(_self, account.value);
      const auto& it = cs.get(id, "Record does not exist" );
      eosio_assert(!it.rewarded, "Already rewarded");
      if (_self.value != account.value) {
        action(
          permission_level{ _self, "active"_n },
          "eosio.token"_n, "transfer"_n,
          std::make_tuple(_self, account, it.reward, std::string("refund"))
        ).send();
      }
      cs.erase(it);
    }
    
    ACTION addrefer(name user, name caseauthor, uint64_t caseid, uint64_t id) {
      require_auth(user);
      cases cs(_self, caseauthor.value);
      cs.get(caseid, "Case does not exist");
      referals rs(_self, _code.value);
      if (id > 0) {
        const auto& it = rs.get(id, "Record does not exist" );
        rs.emplace(_self, [&](auto& row) {
          row.id = rs.available_primary_key();
          row.previd = id;
          row.init = caseauthor;
          row.caseid = caseid;
          row.from = it.to;
          row.to = user;
        });
      } else {
        rs.emplace(_self, [&](auto& row) {
          row.id = rs.available_primary_key();
          row.previd = 0;
          row.init = caseauthor;
          row.caseid = caseid;
          row.from = caseauthor;
          row.to = user;
        });
      }
    }
    
    ACTION givereward(name caseauthor, uint64_t caseid, uint64_t id) {
      require_auth(caseauthor);
      cases cs(_self, caseauthor.value);
      const auto& it = cs.get(caseid, "Case does not exist");
      // eosio_assert(!it.rewarded, "Already rewarded");
      
      cs.modify(it, _code, [&](auto& row) {
        row.rewarded = true;
      });
      
      referals rs(_self, _code.value);
      symbol six = symbol(symbol_code("SIX"), 0);
      asset bonus(1, six);
      
      int64_t n = 0;
      auto iterator = rs.find(id);
      while (iterator != rs.end()) {
        n++;
        action(
          permission_level{ _self, "active"_n },
          "sixdegreesto"_n, "issue"_n,
          std::make_tuple(iterator->from, bonus, std::string("Referral bonus"))
        ).send();
        iterator = rs.find(iterator->previd);
      }
      
      symbol eos = symbol(symbol_code("EOS"), 4);
      int64_t value = it.reward.amount / n;
      asset eos_bonus(value, eos);
      iterator = rs.find(id);
          
      while (iterator != rs.end()) {
        if (iterator->from.value != _self.value) {
          action(
            permission_level{ _self, "active"_n },
            "eosio.token"_n, "transfer"_n,
            std::make_tuple(_self, iterator->from, it.reward, std::string("Referral bonus"))
          ).send();
        }
        iterator = rs.find(iterator->previd);
      }
    }
    
    ACTION removerefer(uint64_t id) {
      referals rs(_self, _code.value);
      auto it = rs.find(id);
      rs.erase(it);
    }
  
  private:
    TABLE caseStruct {
      uint64_t id;
      bool rewarded;
      name account;
      asset reward;
      std::string desc;
      uint64_t primary_key() const { return id; }
    };
    typedef eosio::multi_index<"cases"_n, caseStruct> cases;

    TABLE referalStruct {
      uint64_t id;
      uint64_t previd;
      name init;
      uint64_t caseid;
      name from;
      name to;
      uint64_t primary_key() const { return id; }
    };
    typedef eosio::multi_index<"referals"_n, referalStruct> referals;
};

EOSIO_DISPATCH_WITH_TRANSFER(sixdegreesio, (cancel)(addrefer)(givereward)(removerefer))
