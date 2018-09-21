#include "sha1sum.h"

#include <QNetworkRequest>
#include <QNetworkReply>
#include <QCryptographicHash>
#include <memory>

namespace util {

Sha1Sum::Sha1Sum(QObject* parent) : QObject(parent)
{}

void Sha1Sum::start(const QString& requestUrl)
{
  QNetworkReply* reply(networkAccessManager_.get(QNetworkRequest(requestUrl)));
  std::shared_ptr<QCryptographicHash> sha1hash = std::make_shared<QCryptographicHash>(QCryptographicHash::Sha1);

  connect(reply, &QNetworkReply::downloadProgress, this, &Sha1Sum::progress);

  connect(reply, &QIODevice::readyRead, this, [=] () {
    sha1hash->addData(reply);
  });

  connect(reply, &QNetworkReply::finished, this, [=] () {
    result_ = sha1hash->result().toHex();
    emit finished();
    reply->deleteLater();
  });
  emit started();
}

QString Sha1Sum::result() const
{
  return result_;
}

} // namespace util
