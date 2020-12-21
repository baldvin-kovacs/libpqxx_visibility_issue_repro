#include <pqxx/pqxx>
#include <vector>
#include <cstdlib>
#include <string>

int main() {
  pqxx::connection conn;
  pqxx::nontransaction ntx(conn);
  std::basic_string<std::byte> v;
  ntx.exec_prepared0("foo", v);
}
