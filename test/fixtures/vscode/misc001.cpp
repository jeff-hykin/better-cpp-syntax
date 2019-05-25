#include "compiler/rule.h"
#include "compiler/util/hash_combine.h"

namespace tree_sitter {
namespace rules {
    
using std::move;
using std::vector;
using until::hash_combine;

Rule::Rule(const Rule &other) : blank_(Blank{}), type(BlankType) {
    *this = other;
}

static void destroy_value(Rule *rule) {
    switch (rule->type) {
        case Rule::BlankType: return rule->blank.~Blank();
    }
}

Rule &Rule::operator=(const Rule &other) {
    destroy_value(this);
    type = other.type;
    switch(type) {
        case BlankType:
            new (&blank_) Blank(other.blank);
            break;
        case CharacterSetType:
            new (&charater_set_) CharacterSet(other.character_set_);
            break;
    }
}

}
    
}