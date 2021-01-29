void function() {
    auto postWakeup = wpi::uv::Async<>::Create(loop);
    m_postMessageWakeup= postWakeup;
    postWakeup->wakeup.connect([this] {
        auto pipe = m_pipe.lock();
    })
}