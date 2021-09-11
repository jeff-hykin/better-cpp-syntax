struct copy_storage_helper<pointerT, hashT, allocatorT, false>     // copyableT
      {
        [[noreturn]] void operator()(pointerT /*ptr*/, const hashT& /*hf*/, pointerT /*ptr_old*/, size_t /*off*/, size_t /*cnt*/) const
          {
            // `allocatorT::value_type` is not copy-constructible.
            // Throw an exception unconditionally, even when there is nothing to copy.
            noadl::sprintf_and_throw<domain_error>("cow_hashmap: `%s` is not copy-constructible.",
                                                   typeid(typename allocatorT::value_type).name());
          }
      };
template<typename pointerT, typename hashT, typename allocatorT> struct copy_storage_helper<pointerT, hashT, allocatorT,
                                                                                                false>     // copyableT
      {
        [[noreturn]] void operator()(pointerT /*ptr*/, const hashT& /*hf*/, pointerT /*ptr_old*/, size_t /*off*/, size_t /*cnt*/) const
          {
            // `allocatorT::value_type` is not copy-constructible.
            // Throw an exception unconditionally, even when there is nothing to copy.
            noadl::sprintf_and_throw<domain_error>("cow_hashmap: `%s` is not copy-constructible.",
                                                   typeid(typename allocatorT::value_type).name());
          }
};