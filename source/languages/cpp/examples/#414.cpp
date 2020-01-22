L_API ALenum AL_APIENTRY alGetError(void)
START_API_FUNC
{
    ContextRef context{GetContextRef()};
    if UNLIKELY(!context)
    {
        constexpr ALenum deferror{AL_INVALID_OPERATION};
        WARN("Querying error state on null context (implicitly 0x%04x)\n", deferror);
        if(TrapALError)
        {
#ifdef _WIN32
            if(IsDebuggerPresent())
                DebugBreak();
#elif defined(SIGTRAP)
            raise(SIGTRAP);
#endif
        }
        return deferror;
    }

    return context->mLastError.exchange(AL_NO_ERROR);
}
END_API_FUNC