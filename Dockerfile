FROM python:3.6.6

COPY setup.py /executor/
COPY requirements.txt /executor/
COPY src/ /executor/src/

RUN find . | grep -E "(__pycache__|\.pyc$)" | xargs rm -rf
RUN mkdir executor/resources
RUN pip install -U -r executor/requirements.txt
RUN pip install executor/.
RUN echo "alias run='python executor/src/executor/main.py'" >> ~/.bashrc
