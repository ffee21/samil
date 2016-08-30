from functools import wraps
from flask import Flask, g, request, redirect, url_for

app = Flask(__name__)

import samil.security
import samil.views
import samil.cover