static QAccessibleInterface *factory(const QString &classname, QObject *object) {
    if (classname == QLatin1String("VBase") && object && object->isWidgetType())
        return new Base(static_cast<QWidget *>(object));

    return 0;
}