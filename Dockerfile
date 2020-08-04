FROM nvidia/cuda:9.0-cudnn7-devel

MAINTAINER Andrew Olney "aolney@memphis.edu"

RUN apt-get update \
  && apt-get install -y python-pip python-dev wget curl \
  && pip install --upgrade pip \
  && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
  && install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ \
  && sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
  && apt-get install -y apt-transport-https \
  && apt-get update \
  && apt-get install -y code

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

COPY . /app

## install torch from wheel

RUN wget https://download.pytorch.org/whl/cu90/torch-1.1.0-cp27-cp27mu-linux_x86_64.whl

RUN pip install torch-1.1.0-cp27-cp27mu-linux_x86_64.whl

RUN pip install -r requirements.txt

RUN pip install -r upsa/requirements.txt

#ENTRYPOINT [ "python3" ]  #Flask server

#CMD [ "app.py" ] #Flask server

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]