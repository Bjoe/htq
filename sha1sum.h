#ifndef SHA1SUM_H
#define SHA1SUM_H

#include <QNetworkAccessManager>
#include <QString>
#include <QObject>

namespace util {

class Sha1Sum : public QObject
{
  Q_OBJECT

  Q_PROPERTY(QString result READ result WRITE start NOTIFY finished)

public:
  explicit Sha1Sum(QObject* parent = nullptr);

  Q_INVOKABLE void start(const QString& requestUrl);
  QString result() const;

signals:
  void started();
  void finished();
  void progress(qint64 bytesReceived, qint64 bytesTotal);

private:
  QNetworkAccessManager networkAccessManager_ {};
  QString result_ {};
};

} // namespace util

#endif // SHA1SUM_H
