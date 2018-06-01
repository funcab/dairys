```
1.成功开启POP3/SMTP服务,在第三方客户端登录时，密码框请输入以下授权码：
uhtuuywwpgxhdcid
成功开启IMAP/SMTP服务,在第三方客户端登录时，密码框请输入以下授权码：
uofsqjfrtynkdcic
成功开启Exchange服务,在第三方客户端登录时，密码框请输入以下授权码：
syqctayauiqtdhfd
2.--普通发送
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
import smtplib
def _format_addr(s):
name, addr = parseaddr(s)
return formataddr((Header(name, 'utf-8').encode(), addr))
from_addr = input('From: ')
password = input('Password: ')
to_addr = input('To: ')
smtp_server = 'smtp.qq.com'
msg = MIMEText('hello, send by Python...', 'plain', 'utf-8')
msg['From'] = _format_addr('Python爱好者 <%s>' % from_addr)
msg['Subject'] = Header('来自SMTP的问候……', 'utf-8').encode()
server = smtplib.SMTP(smtp_server, 25)
smtp_port = 25
server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()
server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()
password填开启SMTP时的授权码：已阅
SMTP server:
smtp.qq.com smtp.163.com
3.--添加附件 并将附件图片加载到正文（不要使用html外链）
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
import smtplib
def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr))
from_addr = '2848743470@qq.com'
password = 'uhtuuywwpgxhdcid'
to_addr = '1678144569@qq.com'
smtp_server = 'smtp.qq.com'
# 邮件对象:
msg = MIMEMultipart('related')
msg['From'] = _format_addr('Python爱好者 <%s>' % from_addr)
msg['To'] = _format_addr('管理员 <%s>' % to_addr)
msg['Subject'] = Header('来自SMTP的问候……', 'utf-8').encode()
msg.attach(MIMEText('<html><body><h1>Hello</h1>' +
    '<p><img src="cid:0"></p>' +
    '</body></html>', 'html', 'utf-8'))
# 添加附件就是加上一个MIMEBase，从本地读取一个图片:
#目录用/ 不要用\ 使用斜杠“/”: "c:/test.txt"… 不用反斜杠就没法产生歧义了
with open('E:/python/timg.jpg', 'r+b') as f:
    # 设置附件的MIME和文件名，这里是png类型:
    mime = MIMEBase('image', 'png', filename='timg.jpg')
    # 加上必要的头信息:
    mime.add_header('Content-Disposition', 'attachment', filename='timg.jpg')
    mime.add_header('Content-ID', '<0>')
    mime.add_header('X-Attachment-Id', '0')
    # 把附件的内容读进来:
    mime.set_payload(f.read())
    # 用Base64编码:
    encoders.encode_base64(mime)
    # 添加到MIMEMultipart:
    msg.attach(mime)
server = smtplib.SMTP(smtp_server, 25)
smtp_port = 25
server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()
server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()
4.发送各种附件
其实我们换个思路，就不难理解了。因为我们发送邮件，经过了应用层–>> 传输层–>> 网络层–>>数据链路层–>>物理层。这一系列的步骤，全都变成了比特流了。所以无论是纯文本，图片，亦或是其他类型的文件。在比特流的面前，都是平等的。所以我们发送附件，也是按照发送纯文本的模式来做就行，只不过加上一些特殊的标记即可。
\# 首先是xlsx类型的附件
xlsxpart = MIMEApplication(open('test.xlsx', 'rb').read())
xlsxpart.add_header('Content-Disposition', 'attachment', filename='test.xlsx')
msg.attach(xlsxpart)
\# jpg类型的附件
jpgpart = MIMEApplication(open('beauty.jpg', 'rb').read())
jpgpart.add_header('Content-Disposition', 'attachment', filename='beauty.jpg')
msg.attach(jpgpart)
\# mp3类型的附件
mp3part = MIMEApplication(open('kenny.mp3', 'rb').read())
mp3part.add_header('Content-Disposition', 'attachment', filename='benny.mp3')
msg.attach(mp3part)
from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
import smtplib
def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr))
from_addr = '2848743470@qq.com'
password = 'uhtuuywwpgxhdcid'
to_addr = '1678144569@qq.com'
smtp_server = 'smtp.qq.com'
# 邮件对象:
msg = MIMEMultipart('related')
msg['From'] = _format_addr('Python爱好者 <%s>' % from_addr)
msg['To'] = _format_addr('管理员 <%s>' % to_addr)
msg['Subject'] = Header('来自SMTP的问候……', 'utf-8').encode()
msg.attach(MIMEText('<html><body><h1>Hello</h1>' +
    '<audio controls><source src="cid:1" /></audio>'+
    '<p><img src="cid:0"></p>' +
    '</body></html>', 'html', 'utf-8'))
   
# 添加附件就是加上一个MIMEBase，从本地读取一个图片:
#目录用/ 不要用\
with open('E:/python/timg.jpg', 'r+b') as f:
    # 设置附件的MIME和文件名，这里是png类型:
    mime = MIMEBase('image', 'png', filename='timg.jpg')
    # 加上必要的头信息:
    mime.add_header('Content-Disposition', 'attachment', filename='timg.jpg')
    mime.add_header('Content-ID', '<0>')
    mime.add_header('X-Attachment-Id', '0')
    # 把附件的内容读进来:
    mime.set_payload(f.read())
    # 用Base64编码:
    encoders.encode_base64(mime)
    # 添加到MIMEMultipart:
    msg.attach(mime)
with open('E:/python/first kiss.Mp3', 'r+b') as f:
    # 设置附件的MIME和文件名，这里是png类型:
    mime2 = MIMEBase('first kiss', 'Mp3', filename='first kiss.Mp3')
    # 加上必要的头信息:
    mime2.add_header('Content-Disposition', 'attachment', filename='first kiss.Mp3')
    mime2.add_header('Content-ID', '<1>')
    mime2.add_header('X-Attachment-Id', '1')
    # 把附件的内容读进来:
    mime2.set_payload(f.read())
    # 用Base64编码:
    encoders.encode_base64(mime2)
    # 添加到MIMEMultipart:
    msg.attach(mime2)
server = smtplib.SMTP(smtp_server, 25)
smtp_port = 25
server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()
server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()
```
