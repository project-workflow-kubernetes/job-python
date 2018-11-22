FROM liabifano/executor:0a496c8

COPY setup.py /job/
COPY requirements.txt /job/
COPY src/ /job/src/

RUN find . | grep -E "(__pycache__|\.pyc$)" | xargs rm -rf
RUN pip install -U -r job/requirements.txt
RUN pip install job/.
